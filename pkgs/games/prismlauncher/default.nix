{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
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
    rev = "2203af7eeb48c45398139b583615134efd8d407f";
    sha256 = "sha256-TvVOjkUobYJD9itQYueELJX3wmecvEdCbJ0FinW2mL4=";
  };
in

assert lib.assertMsg (stdenv.isLinux || !gamemodeSupport) "gamemodeSupport is only available on Linux";

stdenv.mkDerivation
rec {
  pname = "prismlauncher-unwrapped";
  version = "7.2";

  src = fetchFromGitHub {
    owner = "PrismLauncher";
    repo = "PrismLauncher";
    rev = version;
    sha256 = "sha256-RArg60S91YKp1Mt97a5JNfBEOf2cmuX4pK3VAx2WfqM=";
  };

  patches = lib.optionals stdenv.isDarwin [
    # https://github.com/PrismLauncher/PrismLauncher/pull/1452
    # These patches allow us to disable the Sparkle updater and cmake bundling
    # TODO: remove these when updating to 8.0
    (fetchpatch {
      name = "disable-sparkle-when-url-is-empty.patch";
      url = "https://github.com/PrismLauncher/PrismLauncher/commit/48e50401968a72846350c6fbd76cc957b64a6b5a.patch";
      hash = "sha256-IFxp6Sj87ogQcMooV4Ql5/4B+C7oTzEk+4tlMud2OLo=";
    })
    (fetchpatch {
      name = "make-install_bundle-cached.patch";
      url = "https://github.com/PrismLauncher/PrismLauncher/commit/a8498b0dab94d0ab6c9e5cf395e5003db541b749.patch";
      hash = "sha256-ji5GGUnzVut9xFXkynqf9aVR9FO/zsqIbt3P9dexJ2I=";
    })
    (fetchpatch {
      name = "dont-include-sparkle-when-not-enabled.patch";
      url = "https://github.com/PrismLauncher/PrismLauncher/commit/51bfda937d47837ed426150ed6f43a60b4ca0ce1.patch";
      hash = "sha256-7hMgANOg4zRIf3F2AfLXGR3dAEBqVmKm/J5SH0G5oCk=";
    })
    (fetchpatch {
      name = "introduce-internal-updater-variable.patch";
      url = "https://github.com/PrismLauncher/PrismLauncher/commit/b1aa9e584624a0732dd55fc6c459524a8abfe6ba.patch";
      hash = "sha256-mm++EfnBxz7NVtKLMb889mMq8F/OdQmzob8OmlvNlRA=";
    })
  ];

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
    mainProgram = "prismlauncher";
    homepage = "https://prismlauncher.org/";
    description = "A free, open source launcher for Minecraft";
    longDescription = ''
      Allows you to have multiple, separate instances of Minecraft (each with
      their own mods, texture packs, saves, etc) and helps you manage them and
      their associated options with a simple interface.
    '';
    platforms = with platforms; linux ++ darwin;
    changelog = "https://github.com/PrismLauncher/PrismLauncher/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ minion3665 Scrumplex getchoo ];
  };
}
