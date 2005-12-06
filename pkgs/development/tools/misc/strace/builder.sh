source $stdenv/setup

export CFLAGS="$CFLAGS -D_LINUX_QUOTA_VERSION=1"

genericBuild
