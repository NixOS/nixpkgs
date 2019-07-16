{ stdenv, fetchFromGitHub, cmake, jdk, zlib, file, makeWrapper, xorg, libpulseaudio, qtbase }:

let
  libpath = with xorg; stdenv.lib.makeLibraryPath [ libX11 libXext libXcursor libXrandr libXxf86vm libpulseaudio ];
in stdenv.mkDerivation rec {
  name = "multimc-${version}";
  version = "0.6.4";
  src = fetchFromGitHub {
    owner = "MultiMC";
    repo = "MultiMC5";
    rev = "0.6.4";
    sha256 = "0z9mhvfsq9m2cmi0dbrjjc51642r6ppdbb8932236gar5j7w3bc2";
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

    # As of https://github.com/MultiMC/MultiMC5/blob/7ea1d68244fdae1e7672fb84199ee71e168b31ca/application/package/linux/multimc.desktop,
    # the desktop icon refers to `multimc`, but the executable actually gets
    # installed as `MultiMC`. Create compatibility symlink to fix the desktop
    # icon.
    ln -sf $out/bin/MultiMC $out/bin/multimc
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
