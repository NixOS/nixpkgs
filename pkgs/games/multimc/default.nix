{ stdenv, fetchFromGitHub, cmake, jdk, zlib, file, makeWrapper, xorg, libpulseaudio, qtbase }:

let
  libpath = with xorg; stdenv.lib.makeLibraryPath [ libX11 libXext libXcursor libXrandr libXxf86vm libpulseaudio ];
in stdenv.mkDerivation rec {
  name = "multimc-${version}";
  version = "0.6.2";
  src = fetchFromGitHub {
    owner = "MultiMC";
    repo = "MultiMC5";
    rev = version;
    sha256 = "07jrr6si8nzfqwf073zhgw47y6snib23ad3imh1ik1nn5r7wqy3c";
    fetchSubmodules = true;
  };
  nativeBuildInputs = [ cmake file makeWrapper ];
  buildInputs = [ qtbase jdk zlib ];

  enableParallelBuilding = true;

  postInstall = ''
    mkdir -p $out/share/{applications,pixmaps}
    cp ../application/resources/multimc/scalable/multimc.svg $out/share/pixmaps
    cp ../application/package/linux/multimc.desktop $out/share/applications
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
