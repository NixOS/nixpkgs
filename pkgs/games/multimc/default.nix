{ stdenv, fetchFromGitHub, cmake, jdk, zlib, file, makeWrapper, xorg, libpulseaudio, qtbase, quazip }:

stdenv.mkDerivation {
  name = "multimc-0.6.1";
  src = fetchFromGitHub {
    owner = "MultiMC";
    repo = "MultiMC5";
    rev = "0.6.1";
    sha256 = "0glsf4vfir8w24bpinf3cx2ninrcp7hpq9cl463wl78dvqfg47kx";
    fetchSubmodules = true;
  };
  buildInputs = [ cmake qtbase jdk zlib file makeWrapper ];

  libpath = with xorg; [ libX11 libXext libXcursor libXrandr libXxf86vm libpulseaudio ];

  enableParallelBuilding = true;

  # the install rule tries to bundle ALL deps into the output for portability
  installPhase = ''
    RESULT=/run/opengl-driver/lib/
    for x in $libpath; do
      RESULT=$x/lib/:$RESULT
    done

    mkdir -pv $out/bin/jars $out/lib
    cp -v MultiMC $out/bin/
    cp -v jars/*.jar $out/bin/jars/ #*/
    cp -v libMultiMC_rainbow.so libMultiMC_nbt++.so libMultiMC_logic.so libMultiMC_gui.so $out/lib
    wrapProgram $out/bin/MultiMC --add-flags "-d \$HOME/.multimc/" --set GAME_LIBRARY_PATH $RESULT --prefix PATH : ${jdk}/bin/
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
