# Call an api POST request agatinst service + endpoint located in $env.api
# e.g. api_post test_data find_skus
export def api_post [service: string, name: string] {
    let req = $env.api | get $service | get $name
    $req.body | to json | http post --content-type $req.type --headers $req.headers $req.url
}

# Creates a basket using a sku retrieved from the test data api by default.
# Provide your own product to create a custom basket
export def --env create_basket [product?: record] {
    let res = $product | default (api_post test_data find_skus)
    let sku = $res | get skus | first
    let payload = {
        id: ""
        items: [
            {
                sku: $sku.skuCode
                price: 49.99
                quantity: 1
                itemName: $sku.itemName
                productName: $sku.productName
                imageUrl: "https://images.dunelm.com/30085024.jpg?$v8srpgrid$&img404=noimagedefault"
            }
        ]
    }
    let req = $env.api | get bms | get add_product
    let basket = $payload | to json | http post --content-type $req.type --headers $req.headers $req.url
    export-env {
        $env.basket_id = $basket.data.id
    }
    print $"Setting ($basket.data.id) to $env.basket_id"
    $basket
}

# Authenticates with the CKS API. 
# Provide your own URL to authenticate against a particular endpoint.
export def --env cks_auth [--url: string] {
    let auth_req = $env.api | get cks | get auth
    let url = $url | default $auth_req.url
    let res = $env.cks.auth | to json | http post --content-type $auth_req.type --headers $auth_req.headers $auth_req.url
    print $"Token retrieved. Expires in ($res.expires_in | into duration --unit sec | format duration hr)."
    export-env {
        $env.CKS_ID_TOKEN = $res.id_token
    }
    $res
}

# Creates a Provisional Order for use with the checkout service by calling 
# the createProvisionalOrder graphql query to the checkout service.
# ** REQUIRES that a basket_id and auth token have been set and added to $env
# by running create_basket and cks_auth **
export def --env create_po [
    --fulfilment-type: string = "HomeDelivery"
    --express-checkout(-e)
    --url: string # Defaults to dunqa url, swap out for branch build
] {
    let cks_config = $env.api.cks.create_provisional_order
    let req_url = $url | default $cks_config.url
    let query = open ( 
        $nu.default-config-dir | 
        path join graphql createProvisionalOrder.gql 
    )

    let payload = {
        query: $query
        variables: {
            input: {
                basketId: $env.basket_id
                source: "WEB"
                selectedFulfilmentType: ($fulfilment_type | default "HomeDelivery")
                isExpressCheckout: $express_checkout
            }
        }
    }

    let res = ( 
        $payload | 
        to json | 
        http post 
        --full 
        --content-type $cks_config.type 
        --headers { Authorization: $"Bearer ($env.CKS_ID_TOKEN)" } 
        $req_url |
        metadata
    )

    export-env {
        $env.PROVISIONAL_ORDER_ID = $res.body.data.createProvisionalOrder.provisionalOrder.id
    }

    print $"Setting ($res.body.data.createProvisionalOrder.provisionalOrder.id) to $env.PROVISIONAL_ORDER_ID"
    $res
}

# Calls the GQL mutation for setPersonalDetailsAndPlaceOrderMutation in the
# checkout service. Uses detault dunqa url located in $env.api.cks, you can
# provide your own to target branch builds or other environments etc.
#
# ** REQUIRES:
#   - $env.CKS_ID_TOKEN to exist (run cks_auth to set)
#   - $env.PROVISIONAL_ORDER_ID to exist (run create_po to set)
export def cks_set_personal_details [url?: string] {
    let cks_config = $env.api.cks.set_personal_details
    let query = open (
        $nu.default-config-dir | 
        path join graphql setPersonalDetailsAndPlaceOrderMutation.gql
    )
    let req_url = $url | default $cks_config.url

    let payload = {
        query: $query
        variables: {
            input: {
                provisionalOrderId: $env.PROVISIONAL_ORDER_ID
                personalDetails: {
                    title: "MR"
                    firstName: "Testfn"
                    lastName: "Testln"
                    phoneNumber: "07777777777"
                    emailAddress: "cancel.me@dunelm.com"
                    marketingOptIn: true
                }
            }
        }
    }
    let res = ( 
        $payload | 
        to json | 
        http post --full 
        --content-type $cks_config.type 
        --headers { Authorization: $"Bearer ($env.CKS_ID_TOKEN)" } 
        $req_url 
    )
    $res
}
