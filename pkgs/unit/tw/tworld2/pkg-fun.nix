{ stdenv
, lib
, fetchurl
, SDL
, qt4
}:

stdenv.mkDerivation rec {
  pname = "tworld2";
  version = "2.2.0";

  src = fetchurl {
    url = "https://tw2.bitbusters.club/downloads/tworld-${version}-src.tar.gz";
    hash = "sha256-USy2F4es0W3xT4aI254OQ02asJKNt3V0Y72LCbXYpfg=";
  };

  buildInputs = [ SDL qt4 ];

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
    homepage = "https://tw2.bitbusters.club/";
    description = "Tile World 2: Tile World is a reimplementation of the game Chip's Challenge";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ drperceptron ];
    platforms = platforms.linux;
  };
}
