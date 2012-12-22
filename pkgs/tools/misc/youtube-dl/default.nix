{stdenv, fetchgit, python}:

let pkgname = "youtube-dl";
    pkgver  = "2012.09.27";
    
in
stdenv.mkDerivation {
  name = "${pkgname}-${pkgver}";

  src = fetchgit {
    url = "git://github.com/rg3/${pkgname}";
    rev = "refs/tags/${pkgver}";
    sha256 = "a98f3339301324ddd6620f7b1353abed807cd8dea5586d6901d7fe69bc6a397c";
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
