{ stdenv, fetchurl, xz, zlib, pkgconfig, libxslt }:

stdenv.mkDerivation rec {
  name = "kmod-18";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/kernel/kmod/${name}.tar.xz";
    sha256 = "e16e57272b54acb219c465b334715cfdddb5d97ff5d8948d4830ca1a372a868e";
  };

  # Disable xz/zlib support to prevent needing them in the initrd.
  
  buildInputs = [ pkgconfig libxslt /* xz zlib */ ];

  configureFlags = [ "--sysconfdir=/etc" /* "--with-xz" "--with-zlib" */ ];

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
    maintainers = [ stdenv.lib.maintainers.shlevy ];
    platforms = stdenv.lib.platforms.linux;
  };
}
