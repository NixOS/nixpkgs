{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
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
  version = "18.4";

  src = fetchFromGitHub {
    owner = "ddnet";
    repo = pname;
    rev = version;
    hash = "sha256-BoEFh0lCd2pCIod5sFafnOs/TQHj/SlIAU8P4o+cjyE=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    name = "${pname}-${version}";
    inherit src;
    hash = "sha256-1MJ5cP4lyRSZ7VRED8RL5scnqpcy8/avmBKW1Zmt6FU=";
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

  patches = [
    (fetchpatch {
      url = "https://github.com/ddnet/ddnet/pull/8517/commits/c840bf45016a30e629f7684df5fab5d07b2c70d5.patch";
      hash = "sha256-UG7pi0Xh/nAHFEF1RIyNZLewF+NFilTLARbV5oUlftc=";
    })
  ];

  postPatch = ''
    substituteInPlace src/engine/shared/storage.cpp \
      --replace /usr/ $out/
  '';

  cmakeFlags = [
    "-DAUTOUPDATE=OFF"
    "-DCLIENT=${if buildClient then "ON" else "OFF"}"
  ];

  # Tests loop forever on Darwin for some reason
  doCheck = !stdenv.isDarwin;
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
    description = "Teeworlds modification with a unique cooperative gameplay";
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
