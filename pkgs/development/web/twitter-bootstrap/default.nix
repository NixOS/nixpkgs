{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "bootstrap";
  version = "4.5.3";

  src = fetchurl {
    url = "https://github.com/twbs/bootstrap/releases/download/v${version}/${pname}-${version}-dist.zip";
    sha256 = "0w87b0vbwsdb4ag359y5pppxjvqnxk1949mszzn8ay2i5h47mjq6";
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
