#!/bin/bash

check_disk() {
	used_space=$(df -h / | awk '/^\/dev/ {print $5}' | sed 's/%//')

	if [[ $used_space -gt 80 ]]; 
		then echo "Your disk is nearly full!"; 
		else echo "Your disk has plenty of space left, you're at $used_space%."; 
	fi
}

check_memory() {
	page_size=$(vm_stat | awk '/^Mach/ {print $8}')
	free_pages=$(vm_stat | awk '/^Pages free/ {print $3}' | sed 's/\.//')
	free_memory=$((page_size*free_pages))
	echo "Page size: $page_size"
	echo "Pages free: $free_pages"
	echo "You have $free_memory of memory available."
}

case $1 in
	disk) check_disk ;;
	mem) check_memory ;;
	*) echo "Pick disk or mem..." && exit 0 ;;
esac

