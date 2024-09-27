#!/bin/bash
if ls -a /opt/interbase/license/.[[:digit:]]*.slip 1> /dev/null 2>&1; then
  IB_PROTOCOL=gds_db
  export IB_PROTOCOL
  INTERBASE=/opt/interbase
  export INTERBASE
  LD_LIBRARY_PATH=/opt/interbase/lib:/opt/interbase/bin:"$LD_LIBRARY_PATH"
  export LD_LIBRARY_PATH
  /opt/interbase/bin/ibguard -f -P gds_db
else
  /opt/interbase/bin/LicenseManagerLauncher -i Console
fi




