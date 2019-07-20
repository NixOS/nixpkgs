# See pkgs/build-support/setup-hooks/role.bash
getHostRole

export NIX_${role_pre}LDFLAGS+=" -lfts"
