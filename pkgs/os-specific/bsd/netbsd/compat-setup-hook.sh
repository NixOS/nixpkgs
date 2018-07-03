# See pkgs/build-support/setup-hooks/role.bash

if ! [ -z "$dontAddLibs" ]; then
    getHostRole

    export NIX_${role_pre}LDFLAGS+=" -lnbcompat"
    export NIX_${role_pre}CFLAGS_COMPILE+=" -DHAVE_NBTOOL_CONFIG_H"
    export NIX_${role_pre}CFLAGS_COMPILE+=" -include nbtool_config.h"
fi
