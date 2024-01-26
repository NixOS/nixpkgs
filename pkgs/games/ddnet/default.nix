{ lib
, stdenv
, fetchFromGitHub
, cargo
, cmake
, ninja
, pkg-config
, rustPlatform
, rustc
, curl
, freetype
, libGLU
, libnotify
, libogg
, libX11
, opusfile
, pcre
, python3
, SDL2
, sqlite
, wavpack
, ffmpeg
, x264
, vulkan-headers
, vulkan-loader
, glslang
, spirv-tools
, gtest
, Carbon
, Cocoa
, OpenGL
, Security
, buildClient ? true
}:

stdenv.mkDerivation rec {
  pname = "ddnet";
  version = "18.0.1";

  src = fetchFromGitHub {
    owner = "ddnet";
    repo = pname;
    rev = version;
    hash = "sha256-CgmFljI9/S544Hm9J4CEqvNgepPM02JgJZJ5HX1d3wU=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    name = "${pname}-${version}";
    inherit src;
    hash = "sha256-oGZOgSPMnrzwEyUvXqdfquCWCFslPfD9C0vT8mILI+s=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    rustc
    cargo
    rustPlatform.cargoSetupHook
  ];

  nativeCheckInputs = [
    gtest
  ];

  buildInputs = [
    curl
    libnotify
    pcre
    python3
    sqlite
  ] ++ lib.optionals buildClient ([
    freetype
    libGLU
    libogg
    opusfile
    SDL2
    wavpack
    ffmpeg
    x264
    vulkan-loader
    vulkan-headers
    glslang
    spirv-tools
  ] ++ lib.optionals stdenv.isLinux [
    libX11
  ] ++ lib.optionals stdenv.isDarwin [
    Carbon
    Cocoa
    OpenGL
    Security
  ]);

  postPatch = ''
    substituteInPlace src/engine/shared/storage.cpp \
      --replace /usr/ $out/
  '';

  cmakeFlags = [
    "-DAUTOUPDATE=OFF"
    "-DCLIENT=${if buildClient then "ON" else "OFF"}"
  ];

  doCheck = true;
  checkTarget = "run_tests";

  postInstall = lib.optionalString (!buildClient) ''
    # DDNet's CMakeLists.txt automatically installs .desktop
    # shortcuts and icons for the client, even if the client
    # is not supposed to be built
    rm -rf $out/share/applications
    rm -rf $out/share/icons
    rm -rf $out/share/metainfo
  '';

  meta = with lib; {
    description = "A Teeworlds modification with a unique cooperative gameplay";
    longDescription = ''
      DDraceNetwork (DDNet) is an actively maintained version of DDRace,
      a Teeworlds modification with a unique cooperative gameplay.
      Help each other play through custom maps with up to 64 players,
      compete against the best in international tournaments,
      design your own maps, or run your own server.
    '';
    homepage = "https://ddnet.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ sirseruju lom ncfavier ];
    mainProgram = "DDNet";
  };
}
