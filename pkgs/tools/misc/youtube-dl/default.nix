{stdenv, fetchgit, python}:

let pkgname = "youtube-dl";
    pkgver  = "2011.12.08";
    
in
stdenv.mkDerivation {
  name = "${pkgname}-${pkgver}";

  src = fetchgit {
    url = "git://github.com/rg3/${pkgname}";
    rev = "661a807c65a154eccdddb875b45e4782ca86132c";
    sha256 = "32fd193b867b122400e9d5d32f6dfaf15704f837a9dc2ff809e1ce06712857ba";
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
