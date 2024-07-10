# See pkgs/build-support/setup-hooks/role.bash
getHostRole

export NIX_LDFLAGS${role_post}+=" -lfts"
