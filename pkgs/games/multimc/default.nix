{ stdenv, fetchFromGitHub, cmake, qt5Full, jdk7, zlib, file, makeWrapper, xorg, libpulseaudio, qt5 }:

let
  libnbt = fetchFromGitHub {
    owner = "MultiMC";
    repo = "libnbtplusplus";
    rev = "5d0ffb50a526173ce58ae57136bf5d79a7e1920d";
    sha256 = "05hnwfb77rmm9ba7n96g4g1sgwqqcmplvbcafsl76yxr6ysgw5jg";
  };
in
stdenv.mkDerivation {
  name = "multimc-5";
  src = fetchFromGitHub {
    owner = "MultiMC";
    repo = "MultiMC5";
    rev = "895d8ab4699f1b50bf03532c967a91f5ecb62a50";
    sha256 = "179vc1iv57fx4g4h1wy8yvyvdm671jnvp6zi8pcr1n6azqhwklds";
  };
  buildInputs = [ cmake qt5Full jdk7 zlib file makeWrapper ];

  libpath = with xorg; [ libX11 libXext libXcursor libXrandr libXxf86vm libpulseaudio ];
  postUnpack = ''
    rmdir $sourceRoot/depends/libnbtplusplus
    cp -r ${libnbt} $sourceRoot/depends/libnbtplusplus
    chmod 755 -R $sourceRoot/depends/libnbtplusplus
    mkdir -pv $sourceRoot/build/
    cp -v ${qt5.quazip.src} $sourceRoot/build/quazip-0.7.1.tar.gz
  '';

  patches = [ ./multimc.patch ];

  enableParallelBuilding = true;

  # the install rule tries to bundle ALL deps into the output for portability
  installPhase = ''
    RESULT=/run/opengl-driver/lib/
    for x in $libpath; do
      RESULT=$x/lib/:$RESULT
    done

    mkdir -pv $out/bin/jars $out/lib
    cp -v MultiMC $out/bin/
    cp -v jars/*.jar $out/bin/jars/
    cp -v librainbow.so libnbt++.so libMultiMC_logic.so $out/lib
    wrapProgram $out/bin/MultiMC --add-flags "-d \$HOME/.multimc/" --set GAME_LIBRARY_PATH $RESULT --prefix PATH : ${jdk7}/bin/
  '';

  meta = {
    homepage = https://multimc.org/;
    description = "A free, open source launcher for Minecraft";
    longDescription = ''
      Allows you to have multiple, separate instances of Minecraft (each with their own mods, texture packs, saves, etc) and helps you manage them and their associated options with a simple interface.
    '';
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = stdenv.lib.maintainers.cleverca22;
  };
}
