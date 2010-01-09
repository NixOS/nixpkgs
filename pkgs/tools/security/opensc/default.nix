{stdenv, fetchurl, libtool, readline, zlib, openssl, libiconv, pcsclite, libassuan, pkgconfig,
libXt }:
stdenv.mkDerivation rec {
  name = "opensc-0.11.12";

  src = fetchurl {
    url = "http://www.opensc-project.org/files/opensc/${name}.tar.gz";
    sha256 = "0zr04qadk9gsabmhnwmk27kb4zgfpy988nwa9s1k3hc3hn3gls3a";
  };

  configureFlags = [ "--enable-pcsc" "--enable-nsplugin" ];
  buildInputs = [ libtool readline zlib openssl pcsclite libassuan pkgconfig
    libXt ] ++
    stdenv.lib.optional (! stdenv.isLinux) libiconv;

  meta = {
    description = "Set of libraries and utilities to access smart cards";
    homepage = http://www.opensc-project.org/opensc/;
    license = "LGPL";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
