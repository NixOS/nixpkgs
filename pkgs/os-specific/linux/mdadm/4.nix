{ stdenv
, fetchurl, groff
, buildPlatform, hostPlatform
}:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "mdadm-4.0";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/raid/mdadm/${name}.tar.xz";
    sha256 = "1ad3mma641946wn5lsllwf0lifw9lps34fv1nnkhyfpd9krffshx";
  };

  # This is to avoid self-references, which causes the initrd to explode
  # in size and in turn prevents mdraid systems from booting.
  allowedReferences = [ stdenv.glibc.out ];

  patches = [ ./no-self-references.patch ];

  makeFlags = [
    "NIXOS=1" "INSTALL=install" "INSTALL_BINDIR=$(out)/sbin"
    "MANDIR=$(out)/share/man" "RUN_DIR=/dev/.mdadm"
  ] ++ stdenv.lib.optionals (hostPlatform != buildPlatform) [
    "CROSS_COMPILE=${stdenv.cc.prefix}"
  ];

  nativeBuildInputs = [ groff ];

  # Attempt removing if building with gcc5 when updating
  NIX_CFLAGS_COMPILE = "-std=gnu89";

  preConfigure = ''
    sed -e 's@/lib/udev@''${out}/lib/udev@' \
        -e 's@ -Werror @ @' \
        -e 's@/usr/sbin/sendmail@/run/wrappers/bin/sendmail@' -i Makefile
  '';

  meta = {
    description = "Programs for managing RAID arrays under Linux";
    homepage = http://neil.brown.name/blog/mdadm;
    platforms = stdenv.lib.platforms.linux;
  };
}
