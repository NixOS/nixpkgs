{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "bootstrap";
  version = "4.5.2";

  src = fetchurl {
    url = "https://github.com/twbs/bootstrap/releases/download/v${version}/${pname}-${version}-dist.zip";
    sha256 = "03brvh7fir9ylfr0c5b6kvf79bkjny0wxw4r5q8x8h2niycrkazg";
  };

  buildInputs = [ unzip ];

  dontBuild = true;
  installPhase = ''
    mkdir $out
    cp -r * $out/
  '';

  meta = {
    description = "Front-end framework for faster and easier web development";
    homepage = "https://getbootstrap.com/";
    license = stdenv.lib.licenses.mit;
  };

}
