{ lib
, stdenv
, fetchFromGitHub
, stripJavaArchivesHook
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
  pname = "fjordlauncher-unwrapped";
  version = "8.3.1";

  src = fetchFromGitHub {
    owner = "unmojang";
    repo = "FjordLauncher";
    rev = finalAttrs.version;
    hash = "sha256-YP2U2Eqyty8uPTEoNdsz9JtF8qLtb98D+Majz8pu2ZI=";
  };

  nativeBuildInputs = [ extra-cmake-modules cmake jdk17 ninja stripJavaArchivesHook ];
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
  ++ lib.optionals stdenv.isDarwin [
    "-DINSTALL_BUNDLE=nodeps"
    "-DMACOSX_SPARKLE_UPDATE_FEED_URL=''"
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}/Applications/"
  ];

  postUnpack = ''
    rm -rf source/libraries/libnbtplusplus
    ln -s ${libnbtplusplus} source/libraries/libnbtplusplus
  '';

  dontWrapQtApps = true;

  meta = {
    mainProgram = "fjordlauncher";
    homepage = "https://github.com/unmojang/FjordLauncher";
    description = "Prism Launcher fork with support for alternative auth servers";
    platforms = with lib.platforms; linux ++ darwin;
    changelog = "https://github.com/unmojang/FjordLauncher/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ evan-goode ];
  };
})
