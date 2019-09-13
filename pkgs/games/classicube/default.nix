{ stdenv, fetchFromGitHub, curl, libX11, libGL, openal, dos2unix, liberation-sans-narrow, bash }:

stdenv.mkDerivation rec {
  pname = "ClassiCube";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "UnknownShadow200";
    repo = pname;
    rev = version;
    sha256 = "1ivxf5ffar9fxnri6xrdk5b77b483hvbjd8d6sifafslpxk3l1r1";
  };

  nativeBuildInputs = [ dos2unix ];

  postUnpack = ''
    sourceRoot=$sourceRoot/src
  '';

  prePatch = ''
    dos2unix Platform.c
  '';

  patches = [ ./font-patch.patch ];

  font = "${liberation-sans-narrow}/share/fonts/truetype/LiberationSansNarrow-Regular.ttf";

  postPatch = ''
    substituteInPlace Platform.c --replace %fontdir% ${font}
    substituteInPlace Makefile --replace JOBS=1 JOBS=${ if enableParallelBuilding then "$NIX_BUILD_CORES" else "1"}
  '';

  buildInputs = [ curl libX11 libGL openal ];

  #We need to copy the game in a writable folder, as it use it's installasion folder to save data
  #TODO: rather patch the function Process_RawGetExePath
  installPhase = ''
    mkdir -p $out/bin
    cp ClassiCube $out/bin/.ClassiCube
    echo "#!${bash}/bin/bash
      mkdir -p ~/.ClassiCube
      rm -f ~/.ClassiCube/ClassiCubeBin
      cp $out/bin/.ClassiCube ~/.ClassiCube/ClassiCubeBin
      ~/.ClassiCube/ClassiCubeBin
      rm -f ~/.ClassiCube/ClassiCubeBin" > $out/bin/ClassiCube
    chmod +x $out/bin/ClassiCube
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Custom Minecraft Classic and ClassiCube client written in C";
    homepage = https://classicube.net;
    maintainers = with maintainers; [ marius851000 ];
    license = licenses.free;
  };
}
