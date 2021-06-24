{ lib, stdenv, fetchurl, bison, flex }:

stdenv.mkDerivation rec {
  pname = "oidentd";
  version = "2.5.0";
  nativeBuildInputs = [ bison flex ];

  src = fetchurl {
    url = "https://files.janikrabe.com/pub/oidentd/releases/${version}/${pname}-${version}.tar.gz";
    sha256 = "1d5mqlknfywbx2bgj7ap7x6qzvz257hhqcqhy6zk45dqpsirdn7a";
  };

  meta = with lib; {
    description = "Configurable Ident protocol server";
    homepage = "https://oidentd.janikrabe.com/";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
