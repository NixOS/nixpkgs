{ lib, stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "bootstrap";
  version = "5.2.0";

  src = fetchurl {
    url = "https://github.com/twbs/bootstrap/releases/download/v${version}/${pname}-${version}-dist.zip";
    sha256 = "sha256-CLykGjXxTZCXIJAyF6YBeEeC3oCz3g5Kcm0kLdOQUks=";
  };

  nativeBuildInputs = [ unzip ];

  dontBuild = true;
  installPhase = ''
    mkdir $out
    cp -r * $out/
  '';

  meta = {
    description = "Front-end framework for faster and easier web development";
    homepage = "https://getbootstrap.com/";
    license = lib.licenses.mit;
  };

}
