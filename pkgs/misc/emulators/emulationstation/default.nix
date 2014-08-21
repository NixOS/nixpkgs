{ stdenv, fetchurl, pkgconfig, cmake, boost, eigen, freeimage, freetype
, mesa, SDL, dejavu_fonts }:

stdenv.mkDerivation rec {
  name = "emulationstation-${version}";
  version = "1.0.2";
  src = fetchurl {
    url = "https://github.com/Aloshi/EmulationStation/archive/v${version}.tar.gz";
    sha256 = "809d67aaa727809c1426fb543e36bb788ca6a3404f8c46dd1917088b57ab5f50";
  };

  buildInputs = [ pkgconfig cmake boost eigen freeimage freetype mesa SDL ];

  prePatch = ''
    sed -i \
      -e 's,/usr\(.*\)/ttf-dejavu\(.*\),${dejavu_fonts}\1\2,' src/Font.cpp
  '';

  buildPhase = "cmake . && make";
  installPhase = ''
    mkdir -p $out/bin
    mv ../emulationstation $out/bin/.
  '';

  meta = {
    description = "A flexible emulator front-end supporting keyboardless navigation and custom system themes";
    homepage = "http://emulationstation.org";
    maintainers = [ stdenv.lib.maintainers.edwtjo ];
    license = stdenv.lib.licenses.mit;
  };
}