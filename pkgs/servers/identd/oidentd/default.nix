{ stdenv, fetchurl, bison, flex }:

stdenv.mkDerivation rec {
  name = "oidentd-${version}";
  version = "2.3.2";
  nativeBuildInputs = [ bison flex ];

  src = fetchurl {
    url = "https://files.janikrabe.com/pub/oidentd/releases/${version}/${name}.tar.gz";
    sha256 = "10c5jkhirkvm1s4v3zdj4micfi6rkfjj32q4k7wjwh1fnzrwyb5n";
  };

  meta = with stdenv.lib; {
    description = "Configurable Ident protocol server";
    homepage = https://oidentd.janikrabe.com/;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
