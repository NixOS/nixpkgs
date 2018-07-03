# See pkgs/build-support/setup-hooks/role.bash

if ! [ -z "$dontAddLibs" ]; then
    getHostRole

    export NIX_${role_pre}LDFLAGS+=" -lfts"
fi
