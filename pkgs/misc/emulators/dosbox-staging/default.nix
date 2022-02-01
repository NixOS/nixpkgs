{ lib
, stdenv
, fetchFromGitHub
, SDL2
, SDL2_net
, alsa-lib
, fluidsynth
, gtest
, libGL
, libGLU
, libogg
, libpng
, makeWrapper
, meson
, libmt32emu
, ninja
, opusfile
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "dosbox-staging";
  version = "0.77.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "07jwmmm1bhfxavlhl854cj8l5iy5hqx5hpwkkjbcwqg7yh9jfs2x";
  };

  nativeBuildInputs = [
    gtest
    makeWrapper
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    SDL2
    SDL2_net
    alsa-lib
    fluidsynth
    libGL
    libGLU
    libmt32emu
    libogg
    libpng
    opusfile
  ];

  hardeningDisable = [ "format" ];

  mesonFlags = [
    "--buildtype=release"
    "-Db_asneeded=true"
    "-Ddefault_library=static"
    "-Dfluidsynth:enable-floats=true"
    "-Dfluidsynth:try-static-deps=true"
    "-Dtry_static_libs=png"
  ];

  postFixup = ''
    # Rename binary, add a wrapper, and copy manual to avoid conflict with
    # vanilla dosbox. Doing it this way allows us to work with frontends and
    # launchers that expect the binary to be named dosbox, but get out of the
    # way of vanilla dosbox if the user desires to install that as well.

    mv $out/bin/dosbox $out/bin/${pname}
    makeWrapper $out/bin/dosbox-staging $out/bin/dosbox
    cp $out/share/man/man1/dosbox.1.gz $out/share/man/man1/${pname}.1.gz
  '';

  meta = with lib; {
    homepage = "https://dosbox-staging.github.io/";
    description = "A modernized DOS emulator";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ joshuafern ];
    platforms = platforms.unix;
    priority = 101;
  };
}
