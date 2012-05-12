{ stdenv, fetchurl, pkgconfig, libxml2, ncurses, libsigcxx, libpar2
, gnutls, libgcrypt }:

stdenv.mkDerivation rec {
  name = "nzbget-0.8.0";

  src = fetchurl {
    url = "mirror://sourceforge/nzbget/${name}.tar.gz";
    sha256 = "15bxsxdbkml9cqpy6zxgv78ff69l8qrv8r201gmzvylpc1ckjsb4";
  };

  buildInputs = [ pkgconfig libxml2 ncurses libsigcxx libpar2 gnutls libgcrypt ];

  postInstall =
    ''
      mkdir -p $out/etc
      cp nzbget.conf.example $out/etc/
    '';

  meta = {
    homepage = http://nzbget.sourceforge.net/;
    license = "GPLv2+";
    description = "A command line tool for downloading files from news servers";
  };
}
