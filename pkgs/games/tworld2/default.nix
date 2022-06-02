{ stdenv
, lib
, fetchurl
, qt4
, SDL
}:

stdenv.mkDerivation rec {
  pname = "tworld2";
  version = "2.2.0";

  src = fetchurl {
    url = "https://tw2.bitbusters.club/downloads/tworld-${version}-src.tar.gz";
    sha256 = "sha256:1y55v2shk2xxcds7bdwdjaq9lka31sgdp2469zqnvldchwbvcb2i";
  };

  buildInputs = [ qt4 SDL ];
  enableParallelBuilding = true;

  postConfigure = ''
    echo "#define COMPILE_TIME \"$(date -ud "@$SOURCE_DATE_EPOCH" '+%Y %b %e %T %Z')\"" >comptime.h
  '';

  makeFlags = [
    "bindir=${placeholder "out"}/bin"
    "sharedir=${placeholder "out"}/share"
    "mandir=${placeholder "out"}/share/man/en"
  ];

  postInstall = ''
    mkdir -p $out/share/doc/${pname}
    cp COPYING README docs/tworld2.html $out/share/doc/${pname}

    mkdir $out/share/icons
    cp tworld.ico tworld2.ico $out/share/icons
  '';

  meta = with lib; {
    description = "Tile World 2: Tile World is a reimplementation of the game Chip's Challenge";
    homepage = "https://tw2.bitbusters.club/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ drperceptron ];
  };
}
