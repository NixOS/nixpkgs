{ stdenv, fetchurl, fetchFromGitHub, pkgconfig, SDL2, glew, xcftools, python, pillow, makeWrapper }:

let
  vasm =
    stdenv.mkDerivation rec {
      name = "vasm-${version}";
      version = "1.8c";
      src = fetchFromGitHub {
        owner = "mbitsnbites";
        repo = "vasm";
        rev = "244f8bbbdf64ae603f9f6c09a3067943837459ec";
        sha256 = "0x4y5q7ygxfjfy2wxijkps9khsjjfb169sbda410vaw0m88wqj5p";
      };
      makeFlags = "CPU=m68k SYNTAX=mot";
      installPhase = ''
        mkdir -p $out/bin
        cp vasmm68k_mot $out/bin
      '';
    };
in
stdenv.mkDerivation rec {
  name = "blastem-${version}";
  version = "0.5.1";
  src = fetchurl {
    url = "https://www.retrodev.com/repos/blastem/archive/3d48cb0c28be.tar.gz";
    sha256 = "07wzbmzp0y8mh59jxg81q17gqagz3psxigxh8dmzsipgg68y6a8r";
  };
  buildInputs = [ pkgconfig SDL2 glew xcftools python pillow vasm makeWrapper ];
  preBuild = ''
    patchShebangs img2tiles.py
  '';
  postBuild = ''
    make menu.bin
  '';
  installPhase = ''
    mkdir -p $out/bin $out/share/blastem
    cp -r {blastem,menu.bin,default.cfg,rom.db,shaders} $out/share/blastem/
    makeWrapper $out/share/blastem/blastem $out/bin/blastem
  '';

  meta = {
    homepage = https://www.retrodev.com/blastem/;
    description = "The fast and accurate Genesis emulator";
    maintainers = with stdenv.lib.maintainers; [ puffnfresh ];
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    # Makefile:140: *** aarch64 is not a supported architecture.  Stop.
    badPlatforms = [ "aarch64-linux" ];
  };
}
