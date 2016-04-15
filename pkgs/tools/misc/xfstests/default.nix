{ stdenv, acl, attr, autoreconfHook, bash, bc, coreutils, e2fsprogs, fetchgit, fio, gawk
, lib, libaio, libcap_progs, libuuid, libxfs, lvm2, openssl, perl, procps, psmisc, su
, time, utillinux, which, writeScript, xfsprogs }:

stdenv.mkDerivation {
  name = "xfstests-2016-01-11";

  src = fetchgit {
    url = "git://oss.sgi.com/xfs/cmds/xfstests.git";
    rev = "dfe582dd396f16ddce1909baab7376e00af07792";
    sha256 = "0hbgccmhcxn5nm87nq13kpi3rcbjadlj65kd03bfjqxhm4gx732q";
  };

  buildInputs = [ acl autoreconfHook attr gawk libaio libuuid libxfs openssl perl ];

  hardeningDisable = [ "format" ];

  patchPhase = ''
    # Patch the destination directory
    sed -i include/builddefs.in -e "s|^PKG_LIB_DIR\s*=.*|PKG_LIB_DIR=$out/lib/xfstests|"

    # Don't canonicalize path to mkfs (in util-linux) - otherwise e.g. mkfs.ext4 isn't found
    sed -i common/config -e 's|^export MKFS_PROG=.*|export MKFS_PROG=mkfs|'

    for f in common/* tools/* tests/*/*; do
      sed -i $f -e 's|/bin/bash|${bash}/bin/bash|'
      sed -i $f -e 's|/bin/true|true|'
      sed -i $f -e 's|/usr/sbin/filefrag|${e2fsprogs}/bin/filefrag|'
      sed -i $f -e 's|hostname -s|hostname|'   # `hostname -s` seems problematic on NixOS
      sed -i $f -e 's|$(_yp_active)|1|'        # NixOS won't ever have Yellow Pages enabled
    done

    for f in src/*.c src/*.sh; do
      sed -e 's|/bin/rm|${coreutils}/bin/rm|' -i $f
      sed -e 's|/usr/bin/time|${time}/bin/time|' -i $f
    done

    patchShebangs .
  '';

  preConfigure = ''
    # The configure scripts really don't like looking in PATH at all...
    export AWK=$(type -P awk)
    export ECHO=$(type -P sort)
    export LIBTOOL=$(type -P libtool)
    export MAKE=$(type -P make)
    export SED=$(type -P sed)
    export SORT=$(type -P sort)
  '';

  postInstall = ''
    patchShebangs $out/lib/xfstests

    mkdir -p $out/bin
    substitute $wrapperScript $out/bin/xfstests-check --subst-var out
    chmod a+x $out/bin/xfstests-check
  '';

  # The upstream package is pretty hostile to packaging; it looks up
  # various paths relative to current working directory, and also
  # wants to write temporary files there. So create a temporary
  # to run from and symlink the runtime files to it.
  wrapperScript = writeScript "xfstests-check" ''
    #!/bin/sh
    set -e
    export RESULT_BASE="$(pwd)/results"

    dir=$(mktemp --tmpdir -d xfstests.XXXXXX)
    trap "rm -rf $dir" EXIT

    chmod a+rx "$dir"
    cd "$dir"
    for f in check common ltp src tests; do
      ln -s @out@/lib/xfstests/$f $f
    done

    export PATH=${lib.makeBinPath [acl attr bc e2fsprogs fio gawk libcap_progs lvm2 perl procps psmisc su utillinux which xfsprogs]}:$PATH
    exec ./check "$@"
  '';

  meta = with stdenv.lib; {
    description = "Torture test suite for filesystems";
    homepage = "http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/cmds/xfstests.git";
    license = licenses.gpl2;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}
