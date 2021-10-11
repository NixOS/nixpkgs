{ lib, fetchFromGitHub, stdenv
, gtest, makeWrapper, meson, ninja, pkg-config
, alsa-lib, fluidsynth, libGL, libGLU, libogg, libpng, munt, opusfile, SDL2, SDL2_net
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

  nativeBuildInputs = [ gtest makeWrapper meson ninja pkg-config ];
  buildInputs = [ alsa-lib fluidsynth libGL libGLU libogg libpng munt opusfile SDL2 SDL2_net ];

  hardeningDisable = [ "format" ];

  mesonFlags = [
    "--buildtype=release"
    "-Ddefault_library=static"
    "-Db_asneeded=true"
    "-Dtry_static_libs=png"
    "-Dfluidsynth:enable-floats=true"
    "-Dfluidsynth:try-static-deps=true"
  ];

  postFixup = ''
    # Rename binary, add a wrapper, and copy manual to avoid conflict with vanilla dosbox.
    # Doing it this way allows us to work with frontends and launchers that expect the
    # binary to be named dosbox, but get out of the way of vanilla dosbox if the user
    # desires to install that as well.
    mv $out/bin/dosbox $out/bin/${pname}
    makeWrapper $out/bin/dosbox-staging $out/bin/dosbox
    cp $out/share/man/man1/dosbox.1.gz $out/share/man/man1/${pname}.1.gz
  '';

  meta = with lib; {
    description = "A modernized DOS emulator";
    homepage = "https://dosbox-staging.github.io/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ joshuafern ];
    platforms = platforms.unix;
    priority = 101;
  };
}
