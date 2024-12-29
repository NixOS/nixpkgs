# See pkgs/build-support/setup-hooks/role.bash
getHostRole

export NIX_LDFLAGS${role_post}+=" -legacy"
export NIX_CFLAGS_COMPILE${role_post}+=" -isystem @out@/0-include"
export NIX_CFLAGS_COMPILE${role_post}+=" -isystem @out@/1-include"
