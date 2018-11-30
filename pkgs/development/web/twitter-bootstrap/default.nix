{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "bootstrap-${version}";
  version = "3.3.7";

  src = fetchurl {
    url = "https://github.com/twbs/bootstrap/releases/download/v${version}/bootstrap-${version}-dist.zip";
    sha256 = "0yqvg72knl7a0rlszbpk7xf7f0cs3aqf9xbl42ff41yh5pzsi67l";
  };

  buildInputs = [ unzip ];

  dontBuild = true;
  installPhase = ''
    mkdir $out
    cp -r * $out/
  '';

  meta = {
    description = "Front-end framework for faster and easier web development";
    homepage = http://getbootstrap.com/;
    license = stdenv.lib.licenses.mit;
  };

}
