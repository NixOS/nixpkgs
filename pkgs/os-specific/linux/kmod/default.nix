{ stdenv, fetchurl, xz, zlib, pkgconfig }:

stdenv.mkDerivation {
  name = "kmod-7";

  src = fetchurl {
    url = ftp://ftp.kernel.org/pub/linux/utils/kernel/kmod/kmod-7.tar.xz;
    sha256 = "1xvsy2zcfdimj4j5b5yyxaqx2byabmwq8qlzjm0hqzpyxxgfw1lq";
  };

  buildInputs = [ pkgconfig xz zlib ];

  configureFlags = [ "--with-xz" "--with-zlib" ];

  patches = [ ./module-dir.patch ];

  meta = {
    homepage = http://www.kernel.org/pub/linux/utils/kernel/kmod/;
    description = "Tools for loading and managing Linux kernel modules";
    maintainers = [ stdenv.lib.maintainers.shlevy ];
    platforms = stdenv.lib.platforms.linux;
  };
}
