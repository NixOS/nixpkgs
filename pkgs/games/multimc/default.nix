{ lib, mkDerivation, fetchFromGitHub, cmake, jdk8, zlib, file, makeWrapper, xorg, libpulseaudio, qtbase, libGL }:

let
  jdk = jdk8;
  libpath = with xorg; lib.makeLibraryPath [ libX11 libXext libXcursor libXrandr libXxf86vm libpulseaudio libGL ];
in mkDerivation rec {
  pname = "multimc";
  version = "unstable-2021-01-17";
  src = fetchFromGitHub {
    owner = "MultiMC";
    repo = "MultiMC5";
    rev = "02887536f773643313f15442fc82cebf616da54a";
    sha256 = "1aykvavcv415lq488hx4ig2a79g5a561jg92gw14fb964r43782i";
    fetchSubmodules = true;
  };
  nativeBuildInputs = [ cmake file makeWrapper ];
  buildInputs = [ qtbase jdk zlib ];

  cmakeFlags = [ "-DMultiMC_LAYOUT=lin-system" ];

  postInstall = ''
    install -Dm644 ../application/resources/multimc/scalable/multimc.svg $out/share/pixmaps/multimc.svg
    install -Dm755 ../application/package/linux/multimc.desktop $out/share/applications/multimc.desktop

    # xorg.xrandr needed for LWJGL [2.9.2, 3) https://github.com/LWJGL/lwjgl/issues/128
    wrapProgram $out/bin/multimc --set GAME_LIBRARY_PATH /run/opengl-driver/lib:${libpath} --prefix PATH : ${jdk}/bin/:${xorg.xrandr}/bin/
  '';

  meta = with lib; {
    homepage = "https://multimc.org/";
    description = "A free, open source launcher for Minecraft";
    longDescription = ''
      Allows you to have multiple, separate instances of Minecraft (each with their own mods, texture packs, saves, etc) and helps you manage them and their associated options with a simple interface.
    '';
    platforms = platforms.linux;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ cleverca22 starcraft66 ];
  };
}
