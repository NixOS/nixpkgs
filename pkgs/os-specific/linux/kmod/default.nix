{ stdenv, fetchurl, xz, zlib, pkgconfig, libxslt }:

let
  systems = [ "/run/current-system/kernel-modules" "/run/booted-system/kernel-modules" "" ];
  modulesDirs = lib.concatMapStringsSep ":" (x: "${x}/lib/modules") systems;

in stdenv.mkDerivation rec {
  name = "kmod-${version}";
  version = "23";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/kernel/kmod/${name}.tar.xz";
    sha256 = "0mc12sx06p8il1ym3hdmgxxb37apn9yv7xij26gddjdfkx8xa0yk";
  };

  buildInputs = [ pkgconfig libxslt xz /* zlib */ ];

  configureFlags = [ "--sysconfdir=/etc" "--with-xz" /* "--with-zlib" */ ];

  patches = [ ./module-dir.patch ];

  postInstall = ''
    ln -s kmod $out/bin/lsmod
    mkdir -p $out/sbin
    for prog in rmmod insmod modinfo modprobe depmod; do
      ln -sv $out/bin/kmod $out/sbin/$prog
    done
  '';

  meta = {
    homepage = http://www.kernel.org/pub/linux/utils/kernel/kmod/;
    description = "Tools for loading and managing Linux kernel modules";
    platforms = stdenv.lib.platforms.linux;
  };
}
