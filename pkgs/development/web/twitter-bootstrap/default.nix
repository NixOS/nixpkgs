{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "bootstrap";
  version = "4.4.1";

  src = fetchurl {
    url = "https://github.com/twbs/bootstrap/releases/download/v${version}/${pname}-${version}-dist.zip";
    sha256 = "1gdzp54f2xyvbw9hnyjlj4s69jvxkxr3hqclq1c8ajmx39s7rymz";
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
