{ stdenv, fetchurl, utillinux }:

stdenv.mkDerivation rec {
  name = "fuse-2.9.5";

  #builder = ./builder.sh;

  src = fetchurl {
    url = "https://github.com/libfuse/libfuse/releases/download/fuse_2_9_5/${name}.tar.gz";
    sha256 = "1dfvbi1p57svbv2sfnbqwpnsk219spvjnlapf35azhgzqlf3g7sp";
  };

  buildInputs = [ utillinux ];

  inherit utillinux;

  preConfigure =
    ''
      export MOUNT_FUSE_PATH=$out/sbin
      export INIT_D_PATH=$TMPDIR/etc/init.d
      export UDEV_RULES_PATH=$out/etc/udev/rules.d

      # Ensure that FUSE calls the setuid wrapper, not
      # $out/bin/fusermount. It falls back to calling fusermount in
      # $PATH, so it should also work on non-NixOS systems.
      export NIX_CFLAGS_COMPILE="-DFUSERMOUNT_DIR=\"/var/setuid-wrappers\""

      sed -e 's@/bin/@${utillinux}/bin/@g' -i lib/mount_util.c
    '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://fuse.sourceforge.net/;
    description = "Kernel module and library that allows filesystems to be implemented in user space";
    platforms = platforms.linux;
    maintainers = [ maintainers.mornfall ];
  };
}
