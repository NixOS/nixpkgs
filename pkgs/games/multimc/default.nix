{ stdenv, fetchFromGitHub, cmake, jdk, zlib, file, makeWrapper, xorg, libpulseaudio, qtbase }:

let
  libpath = with xorg; stdenv.lib.makeLibraryPath [ libX11 libXext libXcursor libXrandr libXxf86vm libpulseaudio ];
in stdenv.mkDerivation rec {
  name = "multimc-${version}";
  version = "0.6.1";
  src = fetchFromGitHub {
    owner = "MultiMC";
    repo = "MultiMC5";
    rev = version;
    sha256 = "0glsf4vfir8w24bpinf3cx2ninrcp7hpq9cl463wl78dvqfg47kx";
    fetchSubmodules = true;
  };
  nativeBuildInputs = [ cmake file makeWrapper ];
  buildInputs = [ qtbase jdk zlib ];

  enableParallelBuilding = true;

  postInstall = ''
    wrapProgram $out/bin/MultiMC --add-flags "-d \$HOME/.multimc/" --set GAME_LIBRARY_PATH /run/opengl-driver/lib:${libpath} --prefix PATH : ${jdk}/bin/
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
