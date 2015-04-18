{ stdenv, fetchurl, unzip, autoconf, automake, libtool, 
  pkgconfig, sodium, python }:
stdenv.mkDerivation rec {
  name = "libmacaroons-${version}";
  version = "HEAD";

  src = fetchurl {
    url = "https://github.com/rescrv/libmacaroons/archive/6febf3ce6c4c77a46d24b40ed29b03ffbfb175a7.zip";
    sha256 = "0b4qgim87398chvc3qhxfqv2l1cyl65rhyknln8lk0gq9y00p1ik";
  };
  buildInputs = [ unzip autoconf automake libtool python sodium pkgconfig ];
  preConfigure = "autoreconf -i";
  
  meta = with stdenv.lib; {
    description = ''Macaroons are flexible authorization credentials that
        support decentralized delegation, attenuation, and verification.'';
    homepage = https://github.com/rescrv/libmacaroons;
    license = licenses.bsd3;
  };
}
