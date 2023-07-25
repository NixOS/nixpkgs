{ lib
, stdenv
, fetchFromGitHub
, cmake
, cmark
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
, gamemodeSupport ? true
}:
let
  libnbtplusplus = fetchFromGitHub {
    owner = "PrismLauncher";
    repo = "libnbtplusplus";
    rev = "2203af7eeb48c45398139b583615134efd8d407f";
    sha256 = "sha256-TvVOjkUobYJD9itQYueELJX3wmecvEdCbJ0FinW2mL4=";
  };
in
stdenv.mkDerivation rec {
  pname = "prismlauncher-unwrapped";
  version = "7.1";

  src = fetchFromGitHub {
    owner = "PrismLauncher";
    repo = "PrismLauncher";
    rev = version;
    sha256 = "sha256-ri4oaeJKmvjJapUASPX10nl4JcLPjA3SgTp2EyaEPWg=";
  };

  nativeBuildInputs = [ extra-cmake-modules cmake jdk17 ninja ];
  buildInputs = [
    qtbase
    zlib
    quazip
    ghc_filesystem
    tomlplusplus
    cmark
  ] ++ lib.optional gamemodeSupport gamemode;

  hardeningEnable = [ "pie" ];

  cmakeFlags = lib.optionals (msaClientID != null) [ "-DLauncher_MSA_CLIENT_ID=${msaClientID}" ]
    ++ lib.optionals (lib.versionOlder qtbase.version "6") [ "-DLauncher_QT_VERSION_MAJOR=5" ];

  postUnpack = ''
    rm -rf source/libraries/libnbtplusplus
    ln -s ${libnbtplusplus} source/libraries/libnbtplusplus
  '';

  dontWrapQtApps = true;

  meta = with lib; {
    homepage = "https://prismlauncher.org/";
    description = "A free, open source launcher for Minecraft";
    longDescription = ''
      Allows you to have multiple, separate instances of Minecraft (each with
      their own mods, texture packs, saves, etc) and helps you manage them and
      their associated options with a simple interface.
    '';
    platforms = platforms.linux;
    changelog = "https://github.com/PrismLauncher/PrismLauncher/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ minion3665 Scrumplex getchoo ];
  };
}
