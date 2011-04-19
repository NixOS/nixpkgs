{ stdenv, fetchurl, pkgconfig, libxml2, ncurses, libsigcxx, libpar2
, gnutls, libgcrypt }:

stdenv.mkDerivation rec {
  name = "nzbget-0.7.0";

  src = fetchurl {
    url = "mirror://sourceforge/nzbget/${name}.tar.gz";
    sha256 = "07kp2rwxzgcr7zrs65hwkva7l3s4czq4vxwmkbhv85k8kz6bp65p";
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
