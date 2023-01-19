#!/bin/bash
if ls -a /opt/interbase/license/.7*.slip 1> /dev/null 2>&1; then
  IB_PROTOCOL=gds_db
  export IB_PROTOCOL
  INTERBASE=/opt/interbase
  export INTERBASE
  /opt/interbase/bin/ibguard -f -P gds_db
else
  /opt/interbase/bin/LicenseManagerLauncher -i Console
fi




