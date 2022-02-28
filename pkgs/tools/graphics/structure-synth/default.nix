{ lib, stdenv, fetchurl, qt4, qmake4Hook, unzip, libGLU, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "structure-synth";
  version = "1.5.0";

  src = fetchurl {
    url = "mirror://sourceforge/structuresynth/StructureSynth-Source-v${version}.zip";
    sha256 = "1kiammx46719az6jzrav8yrwz82nk4m72ybj0kpbnvp9wfl3swbb";
  };

  buildInputs = [ qt4 libGLU ];
  nativeBuildInputs = [ qmake4Hook makeWrapper unzip ];

  # Thanks to https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=672000#15:
  patches = [ ./gcc47.patch ];

  enableParallelBuilding = true;

  preConfigure = ''
    ${qt4}/bin/qmake -project -after "CONFIG+=opengl" -after "QT+=xml opengl script" -after "unix:LIBS+=-lGLU"
  '';

  installPhase = ''
    mkdir -p $out/bin;
    mkdir -p $out/share/Examples $out/share/Misc;
    cp "Structure Synth Source Code" $out/bin/structure-synth;
    cp -r Examples/* $out/share/Examples;
    cp -r Misc/* $out/share/Misc;
  '';

  # Structure Synth expects to see 'Examples' and 'Misc' directory in
  # either $HOME or $PWD - so help it along by moving $PWD to 'share',
  # where we just copied those two directories:
  preFixup = ''
    wrapProgram "$out/bin/structure-synth" --run "cd $out/share"
  '';

  meta = with lib; {
    description = "Application for generating 3D structures by specifying a design grammar";
    homepage = "http://structuresynth.sourceforge.net";
    maintainers = with maintainers; [ hodapp ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
