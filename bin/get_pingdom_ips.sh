#!/bin/bash
wget --quiet -O- https://my.pingdom.com/probes/feed | grep "pingdom:ip" | sed -e 's|</.*||' -e 's|.*>||'
