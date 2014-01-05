{ stdenv, fetchurl, xz, zlib, pkgconfig, libxslt }:

stdenv.mkDerivation rec {
  name = "kmod-15";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/kernel/kmod/${name}.tar.xz";
    sha256 = "17nasn7kpbmbcgyfn9lh50k00bg6qmccxrhzd2m4d6wjw6khxvz8";
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
