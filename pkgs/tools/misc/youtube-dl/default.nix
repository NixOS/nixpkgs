{stdenv, fetchgit, python}:

let pkgname = "youtube-dl";
    pkgver  = "2012.02.27";
    
in
stdenv.mkDerivation {
  name = "${pkgname}-${pkgver}";

  src = fetchgit {
    url = "git://github.com/rg3/${pkgname}";
    rev = "refs/tags/${pkgver}";
    sha256 = "17270ba14f42e8f2813bc6a0eb3674e51592eede69612e156e7d99a96fd147ce";
  };

  buildInputs = [python];
  buildPhase = "sed -i 's|#!/usr/bin/env python|#!#{python}/bin/python|' youtube-dl";

  installPhase = ''
    ensureDir $out/bin
    cp youtube-dl $out/bin
  '';

  meta = {
    description = "A small command-line program to download videos from YouTube.com and a few more sites";
    homepage = http://rg3.github.com/youtube-dl/;
    maintainers = [
      stdenv.lib.maintainers.bluescreen303
    ];
  };
}
