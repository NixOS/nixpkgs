{ stdenv, fetchFromGitHub, fetchpatch, utillinux
, autoconf, automake, libtool, gettext }:

stdenv.mkDerivation rec {
  name = "fuse-${version}";
  version = "2.9.7";

  src = fetchFromGitHub {
    owner = "libfuse";
    repo = "libfuse";
    rev = name;
    sha256 = "1wyjjfb7p4jrkk15zryzv33096a5fmsdyr2p4b00dd819wnly2n2";
  };

  buildInputs = [ utillinux autoconf automake libtool gettext ];

  patches = stdenv.lib.optional stdenv.isAarch64 (fetchpatch {
    url = "https://github.com/libfuse/libfuse/commit/914871b20a901e3e1e981c92bc42b1c93b7ab81b.patch";
    sha256 = "1w4j6f1awjrycycpvmlv0x5v9gprllh4dnbjxl4dyl2jgbkaw6pa";
  });

  preConfigure =
    ''
      export MOUNT_FUSE_PATH=$out/sbin
      export INIT_D_PATH=$TMPDIR/etc/init.d
      export UDEV_RULES_PATH=$out/etc/udev/rules.d

      # Ensure that FUSE calls the setuid wrapper, not
      # $out/bin/fusermount. It falls back to calling fusermount in
      # $PATH, so it should also work on non-NixOS systems.
      export NIX_CFLAGS_COMPILE="-DFUSERMOUNT_DIR=\"/run/wrappers/bin\""

      sed -e 's@/bin/@${utillinux}/bin/@g' -i lib/mount_util.c
      sed -e 's@CONFIG_RPATH=/usr/share/gettext/config.rpath@CONFIG_RPATH=${gettext}/share/gettext/config.rpath@' -i makeconf.sh

      ./makeconf.sh
    '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/libfuse/libfuse;
    description = "Kernel module and library that allows filesystems to be implemented in user space";
    platforms = platforms.linux;
    maintainers = [ maintainers.mornfall ];
  };
}
