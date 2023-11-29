{ lib
, stdenv
, fetchFromGitHub
, canonicalize-jars-hook
, cmake
, cmark
, Cocoa
, ninja
, jdk17
, zlib
, qtbase
, quazip
, extra-cmake-modules
, tomlplusplus
, ghc_filesystem
, gamemode
, msaClientID ? null
, gamemodeSupport ? stdenv.isLinux
,
}:
let
  libnbtplusplus = fetchFromGitHub {
    owner = "PrismLauncher";
    repo = "libnbtplusplus";
    rev = "a5e8fd52b8bf4ab5d5bcc042b2a247867589985f";
    hash = "sha256-A5kTgICnx+Qdq3Fir/bKTfdTt/T1NQP2SC+nhN1ENug=";
  };
in

assert lib.assertMsg (stdenv.isLinux || !gamemodeSupport) "gamemodeSupport is only available on Linux";

stdenv.mkDerivation (finalAttrs: {
  pname = "pollymc-unwrapped";
  version = "8.0";

  src = fetchFromGitHub {
    owner = "fn2006";
    repo = "PollyMC";
    rev = finalAttrs.version;
    hash = "sha256-DF1lxQHetDKZEpRrRZ0HQWqqMDAGNiTZoCJUARdXFSk=";
  };

  nativeBuildInputs = [ extra-cmake-modules cmake jdk17 ninja canonicalize-jars-hook ];
  buildInputs =
    [
      qtbase
      zlib
      quazip
      ghc_filesystem
      tomlplusplus
      cmark
    ]
    ++ lib.optional gamemodeSupport gamemode
    ++ lib.optionals stdenv.isDarwin [ Cocoa ];

  hardeningEnable = lib.optionals stdenv.isLinux [ "pie" ];

  cmakeFlags = [
    # downstream branding
    "-DLauncher_BUILD_PLATFORM=nixpkgs"
  ] ++ lib.optionals (msaClientID != null) [ "-DLauncher_MSA_CLIENT_ID=${msaClientID}" ]
  ++ lib.optionals (lib.versionOlder qtbase.version "6") [ "-DLauncher_QT_VERSION_MAJOR=5" ]
  ++ lib.optionals stdenv.isDarwin [ "-DINSTALL_BUNDLE=nodeps" "-DMACOSX_SPARKLE_UPDATE_FEED_URL=''" ];

  postUnpack = ''
    rm -rf source/libraries/libnbtplusplus
    ln -s ${libnbtplusplus} source/libraries/libnbtplusplus
  '';

  dontWrapQtApps = true;

  meta = with lib; {
    mainProgram = "pollymc";
    homepage = "https://github.com/fn2006/PollyMC";
    description = "DRM-free Prism Launcher fork with support for custom auth servers";
    platforms = with platforms; linux ++ darwin;
    changelog = "https://github.com/fn2006/PollyMC/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ evan-goode ];
  };
})
