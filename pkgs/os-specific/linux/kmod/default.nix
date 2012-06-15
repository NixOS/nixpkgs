{ stdenv, fetchurl, xz, zlib, pkgconfig }:

stdenv.mkDerivation rec {
  name = "kmod-8";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/kernel/kmod/${name}.tar.xz";
    sha256 = "0kbkjzcyhkwgcplwa29n0f03ccwpg4df83pdl5nkvsk2rzgx3xrm";
  };

  # Disable xz/zlib support to prevent needing them in the initrd.
  
  buildInputs = [ pkgconfig /* xz zlib */ ];

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
