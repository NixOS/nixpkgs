{ stdenv, fetchurl
, autoconf, automake
, unzip, pkgconfig
, file, fuse, libmtp }:

stdenv.mkDerivation rec {
  version = "0.5";
  name = "jmtpfs-${version}";

  src = fetchurl {
    url = "https://github.com/JasonFerrara/jmtpfs/archive/v0.5.zip";
    sha256 = "09fw4g350mjz1mnga7ws5nvnsnfzs8s7cscl300mas1m9s6vmhz6";
  };

  buildInputs = [ autoconf automake file fuse libmtp pkgconfig unzip ];

  meta = {
    description = "A FUSE filesystem for MTP devices like Android phones";
    homepage = https://github.com/JasonFerrara/jmtpfs;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.coconnor ];
  };
}
