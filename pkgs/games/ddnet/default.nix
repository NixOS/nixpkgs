{ lib
, stdenv
, fetchFromGitHub
<<<<<<< HEAD
=======
, fetchpatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
}:

stdenv.mkDerivation rec {
  pname = "ddnet";
<<<<<<< HEAD
  version = "17.2.1";
=======
  version = "16.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ddnet";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-FJnwabNEEGZDM9wNWMGclFv2IMlXg4Ob3PEbGiGQKKc=";
=======
    hash = "sha256-DOP2v82346YQtL55Ix0gn9cTpvbO1ooeCIGRpgEMFpA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    name = "${pname}-${version}";
    inherit src;
<<<<<<< HEAD
    hash = "sha256-hUrsumBiKovSD7xT1PgH2Q+7HYgyxnFnz33YJPdd5+c=";
=======
    hash = "sha256-xTB8wg4PIdg7MB3545zN83/41fUsqFE2Sk5aTXrGhps=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    freetype
    libGLU
    libnotify
    libogg
    libX11
    opusfile
    pcre
    python3
    SDL2
    sqlite
    wavpack
    ffmpeg
    x264
    vulkan-loader
    vulkan-headers
    glslang
    spirv-tools
  ] ++ lib.optionals stdenv.isDarwin [ Carbon Cocoa OpenGL Security ];

  postPatch = ''
    substituteInPlace src/engine/shared/storage.cpp \
      --replace /usr/ $out/
  '';

  cmakeFlags = [
    "-DAUTOUPDATE=OFF"
  ];

  doCheck = true;
  checkTarget = "run_tests";

  meta = with lib; {
    description = "A Teeworlds modification with a unique cooperative gameplay.";
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
