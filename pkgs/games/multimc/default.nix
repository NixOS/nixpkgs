{ stdenv, fetchFromGitHub, cmake, qt5Full, jdk8, zlib, file, makeWrapper, xorg, libpulseaudio, qt5 }:

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
    rev = "4ca6878743119647213ae02d9a9bb1a410768110";
    sha256 = "1cp2j0nnlp1x0g3rygpfrvmmg4am3qv6aqz5nn964ljm7xpnza8k";
  };
  buildInputs = [ cmake qt5Full jdk8 zlib file makeWrapper ];

  libpath = with xorg; [ libX11 libXext libXcursor libXrandr libXxf86vm libpulseaudio ];
  postUnpack = ''
    rmdir $sourceRoot/libraries/libnbtplusplus
    cp -r ${libnbt} $sourceRoot/libraries/libnbtplusplus
    chmod 755 -R $sourceRoot/libraries/libnbtplusplus
    mkdir -pv $sourceRoot/build/
    cp -v ${qt5.quazip.src} $sourceRoot/build/quazip-0.7.1.tar.gz
  '';


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
    cp -v librainbow.so libnbt++.so libMultiMC_logic.so libMultiMC_gui.so $out/lib
    wrapProgram $out/bin/MultiMC --add-flags "-d \$HOME/.multimc/" --set GAME_LIBRARY_PATH $RESULT --prefix PATH : ${jdk8}/bin/
  '';

  meta = with stdenv.lib; {
    homepage = https://multimc.org/;
    description = "A free, open source launcher for Minecraft";
    longDescription = ''
      Allows you to have multiple, separate instances of Minecraft (each with their own mods, texture packs, saves, etc) and helps you manage them and their associated options with a simple interface.
    '';
    platforms = platforms.linux;
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.cleverca22 ];
  };
}
