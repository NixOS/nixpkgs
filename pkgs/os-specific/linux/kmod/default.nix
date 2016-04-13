{ stdenv, fetchurl, xz, zlib, pkgconfig, libxslt }:

stdenv.mkDerivation rec {
  name = "kmod-22";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/kernel/kmod/${name}.tar.xz";
    sha256 = "10lzfkmnpq6a43a3gkx7x633njh216w0bjwz31rv8a1jlgg1sfxs";
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
