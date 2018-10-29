#!/bin/bash
myIP=$(dig +short myip.opendns.com @resolver1.opendns.com)
echo $myIP
