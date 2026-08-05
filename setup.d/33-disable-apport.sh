#!/bin/bash

set -x
set -e

# Stop Ubuntu's crash reporter from showing dialogs to contestants.
systemctl disable --now apport.service || true

if [ -f /etc/default/apport ]; then
    sed -i 's/^enabled=.*/enabled=0/' /etc/default/apport
else
    echo 'enabled=0' > /etc/default/apport
fi
