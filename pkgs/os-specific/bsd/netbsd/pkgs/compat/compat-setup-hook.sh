# See pkgs/build-support/setup-hooks/role.bash
getHostRole

export NIX_LDFLAGS${role_post}+=" -lnbcompat"
export NIX_CFLAGS_COMPILE${role_post}+=" -DHAVE_NBTOOL_CONFIG_H"
