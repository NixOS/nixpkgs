{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "bootstrap";
  version = "4.3.1";

  src = fetchurl {
    url = "https://github.com/twbs/bootstrap/releases/download/v${version}/${pname}-${version}-dist.zip";
    sha256 = "08rkg4q8x36k03g1d81brhncrzb98sh8r53a5wg3i4p1nwqgv3w8";
  };

  buildInputs = [ unzip ];

  dontBuild = true;
  installPhase = ''
    mkdir $out
    cp -r * $out/
  '';

  meta = {
    description = "Front-end framework for faster and easier web development";
    homepage = https://getbootstrap.com/;
    license = stdenv.lib.licenses.mit;
  };

}
