{
  lib,
  stdenv,
  fetchzip,
  fetchpatch,
  cmake,
  pkg-config,
  SDL2,
  libpng,
  zlib,
  xz,
  freetype,
  fontconfig,
  nlohmann_json,
  curl,
  icu,
  harfbuzz,
  expat,
  glib,
  pcre2,
  withOpenGFX ? true,
  withOpenSFX ? true,
  withOpenMSX ? true,
  withFluidSynth ? true,
  fluidsynth,
  soundfont-fluid,
  soundfont-name ? "FluidR3_GM2-2",
  libsndfile,
  flac,
  libogg,
  libvorbis,
  libopus,
  libmpg123,
  pulseaudio,
  alsa-lib,
  libjack2,
  makeWrapper,
}:

let
  opengfx = fetchzip {
    url = "https://cdn.openttd.org/opengfx-releases/7.1/opengfx-7.1-all.zip";
    sha256 = "sha256-daJ/Qwg/okpmLQkXcCjruIiP8GEwyyp02YWcGQepxzs=";
  };

  opensfx = fetchzip {
    url = "https://cdn.openttd.org/opensfx-releases/1.0.3/opensfx-1.0.3-all.zip";
    sha256 = "sha256-QmfXizrRTu/fUcVOY7tCndv4t4BVW+fb0yUi8LgSYzM=";
  };

  openmsx = fetchzip {
    url = "https://cdn.openttd.org/openmsx-releases/0.4.2/openmsx-0.4.2-all.zip";
    sha256 = "sha256-Cgrg2m+uTODFg39mKgX+hE8atV7v5bVyZd716vSZB8M=";
  };
in
stdenv.mkDerivation rec {
  pname = "openttd";
  version = "14.1";

  src = fetchzip {
    url = "https://cdn.openttd.org/openttd-releases/${version}/${pname}-${version}-source.tar.xz";
    hash = "sha256-YT4IE/rJ9pnpeMWKbOra6AbSUwW19RwOKlXkxwoMeKY=";
  };

  patches = [
    # Fix build against icu-76:
    #   https://github.com/OpenTTD/OpenTTD/pull/13048
    (fetchpatch {
      name = "icu-75.patch";
      url = "https://github.com/OpenTTD/OpenTTD/commit/14fac2ad37bfb9cec56b4f9169d864f6f1c7b96e.patch";
      hash = "sha256-L35ybnTKPO+HVP/7ZYzWM2mA+s1RAywhofSuzpy/6sc=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];
  buildInputs =
    [
      SDL2
      libpng
      xz
      zlib
      freetype
      fontconfig
      nlohmann_json
      curl
      icu
      harfbuzz
      expat
      glib
      pcre2
    ]
    ++ lib.optionals withFluidSynth [
      fluidsynth
      soundfont-fluid
      libsndfile
      flac
      libogg
      libvorbis
      libopus
      libmpg123
      pulseaudio
      alsa-lib
      libjack2
    ];

  prefixKey = "--prefix-dir=";

  configureFlags = [ "--without-liblzo2" ];

  postPatch = ''
    substituteInPlace src/music/fluidsynth.cpp \
      --replace-fail "/usr/share/soundfonts/default.sf2" \
                     "${soundfont-fluid}/share/soundfonts/${soundfont-name}.sf2"
  '';

  postInstall =
    lib.optionalString withOpenGFX ''
      cp ${opengfx}/*.tar $out/share/games/openttd/baseset
    ''
    + lib.optionalString withOpenSFX ''
      cp ${opensfx}/*.tar $out/share/games/openttd/baseset
    ''
    + lib.optionalString withOpenMSX ''
      tar -xf ${openmsx}/*.tar -C $out/share/games/openttd/baseset
    '';

  meta = with lib; {
    description = ''Open source clone of the Microprose game "Transport Tycoon Deluxe"'';
    mainProgram = "openttd";
    longDescription = ''
      OpenTTD is a transportation economics simulator. In single player mode,
      players control a transportation business, and use rail, road, sea, and air
      transport to move goods and people around the simulated world.

      In multiplayer networked mode, players may:
        - play competitively as different businesses
        - play cooperatively controlling the same business
        - observe as spectators
    '';
    homepage = "https://www.openttd.org/";
    changelog = "https://cdn.openttd.org/openttd-releases/${version}/changelog.txt";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      jcumming
      fpletz
    ];
  };
}
