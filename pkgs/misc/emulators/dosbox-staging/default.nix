{ stdenv, lib, fetchFromGitHub, autoconf, autoconf-archive, automake, autoreconfHook, pkgconfig, alsaLib, SDL2, SDL2_net, libGL, libGLU, libogg, opusfile }:

stdenv.mkDerivation rec {
  pname = "dosbox-staging";
  version = "0.75.0";

  src = fetchFromGitHub {
    owner = "dreamer";
    repo = pname;
    rev = "v${version}";
    sha256 = "00n5k2ya7ml55wvrk40p9il01f9k2q2b5g9b20n5zvbgv0d8c5ps";
  };

  enableParallelBuilding = true;
  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ pkgconfig autoconf autoconf-archive automake autoreconfHook ];
  buildInputs = [ SDL2 libGL libGLU libogg opusfile alsaLib SDL2_net ];

  preBuild = ''
    makeFlagsArray+=(CFLAGS="-O3 -DNDEBUG" CXXFLAGS="-O3 -DNDEBUG")
  '';

  postInstall = ''
    mkdir -p $out/share/applications
    cp $src/contrib/linux/dosbox-staging.desktop $out/share/applications/dosbox-staging.desktop
    mkdir -p $out/share/icons/hicolor/scalable/apps
    cp $src/contrib/icons/dosbox-staging.svg $out/share/icons/hicolor/scalable/apps/dosbox-staging.svg
  '';

  meta = with stdenv.lib; {
    description = "A modernized DOS emulator";
    homepage = "https://dosbox-staging.github.io/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ joshuafern ];
    platforms = platforms.unix;
  };
}
