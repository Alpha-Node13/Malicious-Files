#!/bin/bash
while read -r host; do
  sslscan "$host"
done < "$1"
