{ stdenv, acl, attr, autoconf, automake, bash, bc, coreutils, e2fsprogs, fetchgit, fio, gawk, keyutils
, lib, libaio, libcap, libtool, libuuid, libxfs, lvm2, openssl, perl, procps, psmisc, quota, su
, time, utillinux, which, writeScript, xfsprogs }:

stdenv.mkDerivation {
  name = "xfstests-2017-07-16";

  src = fetchgit {
    url = "git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git";
    rev = "c3893c2dc623a07b1ace8e72ee4beb29f8bfae15";
    sha256 = "1p42dakry4r2366hdgj4i1wcnjs4qk0bfmyr70r1n7s7ykvnvnrl";
  };

  nativeBuildInputs = [ autoconf automake libtool ];
  buildInputs = [ acl attr gawk libaio libuuid libxfs openssl perl ];

  hardeningDisable = [ "format" ];
  enableParallelBuilding = true;

  patchPhase = ''
    # Patch the destination directory
    sed -i include/builddefs.in -e "s|^PKG_LIB_DIR\s*=.*|PKG_LIB_DIR=$out/lib/xfstests|"

    # Don't canonicalize path to mkfs (in util-linux) - otherwise e.g. mkfs.ext4 isn't found
    sed -i common/config -e 's|^export MKFS_PROG=.*|export MKFS_PROG=mkfs|'

    # Move the Linux-specific test output files to the correct place, or else it will
    # try to move them at runtime. Also nuke all the irix crap.
    for f in tests/*/*.out.linux; do
      mv $f $(echo $f | sed -e 's/\.linux$//')
    done
    rm -f tests/*/*.out.irix

    # Fix up lots of impure paths
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
    export ECHO=$(type -P echo)
    export LIBTOOL=$(type -P libtool)
    export MAKE=$(type -P make)
    export SED=$(type -P sed)
    export SORT=$(type -P sort)

    make configure
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
    for f in $(cd @out@/lib/xfstests; echo *); do
      ln -s @out@/lib/xfstests/$f $f
    done

    export PATH=${lib.makeBinPath [acl attr bc e2fsprogs fio gawk keyutils libcap lvm2 perl procps psmisc quota utillinux which xfsprogs]}:$PATH
    exec ./check "$@"
  '';

  meta = with stdenv.lib; {
    description = "Torture test suite for filesystems";
    homepage = "https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/";
    license = licenses.gpl2;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}
