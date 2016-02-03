{ stdenv, fetchurl, groff }:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "mdadm-3.3.4";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/raid/mdadm/${name}.tar.xz";
    sha256 = "0s6a4bq7v7zxiqzv6wn06fv9f6g502dp047lj471jwxq0r9z9rca";
  };

  # This is to avoid self-references, which causes the initrd to explode
  # in size and in turn prevents mdraid systems from booting.
  allowedReferences = [ stdenv.glibc.out ];

  patches = [ ./no-self-references.patch ];

  makeFlags = [
    "NIXOS=1" "INSTALL=install" "INSTALL_BINDIR=$(out)/sbin"
    "MANDIR=$(out)/share/man" "RUN_DIR=/dev/.mdadm"
  ] ++ stdenv.lib.optionals (stdenv ? cross) [
    "CROSS_COMPILE=${stdenv.cross.config}-"
  ];

  nativeBuildInputs = [ groff ];

  # Attempt removing if building with gcc5 when updating
  NIX_CFLAGS_COMPILE = "-std=gnu89";

  preConfigure = ''
    sed -e 's@/lib/udev@''${out}/lib/udev@' -e 's@ -Werror @ @' -i Makefile
  '';

  meta = {
    description = "Programs for managing RAID arrays under Linux";
    homepage = http://neil.brown.name/blog/mdadm;
  };
}
