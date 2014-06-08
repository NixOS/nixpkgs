{ stdenv, fetchurl, mono, makeWrapper
, SDL2, freetype, openal
}:

let
  version = "20131223";
in stdenv.mkDerivation rec {
  name = "openra-${version}";

  meta = with stdenv.lib; {
    description = "Real Time Strategy game engine recreates the C&C titles";
    homepage    = "http://www.open-ra.org/";
    license     = licenses.gpl3;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ iyzsong ];
  };

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "https://github.com/OpenRA/OpenRA/archive/release-${version}.tar.gz";
    sha256 = "1gfz6iiccajp86qc7xw5w843bng69k9zplvmipxxbspvr7byhw0c";
  };

  dontStrip = true;

  nativeBuildInputs = [ mono makeWrapper ];

  patchPhase = ''
    sed -i 's/^VERSION.*/VERSION = release-${version}/g' Makefile
  '';

  preConfigure = ''
    makeFlags="prefix=$out"
    make version
  '';

  postInstall = with stdenv.lib; let
    runtime = makeLibraryPath [ SDL2 freetype openal ];
  in ''
    wrapProgram $out/bin/openra \
      --prefix PATH : "${mono}/bin" \
      --prefix LD_LIBRARY_PATH : "${runtime}"
  '';
}
