{ stdenv, fetchurl, bison, flex }:

stdenv.mkDerivation rec {
  name = "oidentd-${version}";
  version = "2.3.1";
  nativeBuildInputs = [ bison flex ];

  src = fetchurl {
    url = "https://files.janikrabe.com/pub/oidentd/releases/${version}/${name}.tar.gz";
    sha256 = "1sljid4jyz9gjyx8wy3xd6bq4624dxs422nqd3mcxnsvgxr6d6zd";
  };

  meta = with stdenv.lib; {
    description = "Configurable Ident protocol server";
    homepage = https://oidentd.janikrabe.com/;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
