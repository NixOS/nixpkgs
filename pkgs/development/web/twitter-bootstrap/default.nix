{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "bootstrap-${version}";
  version = "3.4.1";

  src = fetchurl {
    url = "https://github.com/twbs/bootstrap/releases/download/v${version}/bootstrap-${version}-dist.zip";
    sha256 = "0bnrxyryl4kyq250k4n2lxgkddfs9lxhqd6gq8x3kg9wfz7r75yl";
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
