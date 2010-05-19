{stdenv, fetchurl, libtool, readline, zlib, openssl, libiconv, pcsclite,
  libassuan1, pkgconfig, libXt, pinentry}:

stdenv.mkDerivation rec {
  name = "opensc-0.11.7";

  src = fetchurl {
    url = "http://www.opensc-project.org/files/opensc/${name}.tar.gz";
    sha256 = "0781qi0bsm01wdhkb1vd3ra9wkwgyjcm2w87jb2r53msply2gavd";
  };

  configureFlags = [ "--enable-pcsc" "--enable-nsplugin"
    "--with-pcsc-provider=${pcsclite}/lib/libpcsclite.so.1"
    "--with-pinentry=${pinentry}/bin/pinentry" ];

  buildInputs = [ libtool readline zlib openssl pcsclite libassuan1 pkgconfig
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
