{ stdenv, fetchurl, unzip, python, asciidoc, re2c }:

stdenv.mkDerivation rec {
  name = "ninja-1.2.0";

  src = fetchurl {
    url = "https://github.com/martine/ninja/archive/v1.2.0.zip";
    sha256 = "15ynh806ah37bqb57hcs3mj2g82900sncp6n3bssfggb4azgjlh3";
  };

  buildInputs = [ python asciidoc unzip re2c ];

  buildPhase = ''
    python bootstrap.py
    asciidoc doc/manual.asciidoc
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ninja $out/bin/

    mkdir -p $out/share/doc/ninja
    cp doc/manual.asciidoc $out/share/doc/ninja/
    cp doc/manual.html $out/share/doc/ninja/
  '';

  homepage = http://martine.github.io/ninja/;
}
