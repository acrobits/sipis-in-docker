#!/bin/sh
test -f /etc/sipis/sipis.key || head --bytes 16 /dev/urandom > /etc/sipis/sipis.key

