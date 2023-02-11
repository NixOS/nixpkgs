{ lib, stdenv, fetchurl, bison, flex }:

stdenv.mkDerivation rec {
  pname = "oidentd";
  version = "3.0.0";
  nativeBuildInputs = [ bison flex ];

  src = fetchurl {
    url = "https://files.janikrabe.com/pub/oidentd/releases/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-j+ekHTUf4Ny4a43/FoSARDowWTglJmvqrY3PlF2Jnio=";
  };

  meta = with lib; {
    description = "Configurable Ident protocol server";
    homepage = "https://oidentd.janikrabe.com/";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
