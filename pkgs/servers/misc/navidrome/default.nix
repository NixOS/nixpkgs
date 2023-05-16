<<<<<<< HEAD
{ buildGoModule
, fetchFromGitHub
, fetchNpmDeps
, lib
, nodejs
, npmHooks
=======
{ callPackage
, buildGoModule
, fetchFromGitHub
, lib
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pkg-config
, stdenv
, ffmpeg-headless
, taglib
, zlib
, makeWrapper
, nixosTests
<<<<<<< HEAD
, nix-update-script
, ffmpegSupport ? true
}:

buildGoModule rec {
  pname = "navidrome";
=======
, ffmpegSupport ? true
}:

let

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  version = "0.49.3";

  src = fetchFromGitHub {
    owner = "navidrome";
    repo = "navidrome";
    rev = "v${version}";
    hash = "sha256-JBvY+0QAouEc0im62aVSJ27GAB7jt0qVnYtc6VN2qTA=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-C8w/qCts8VqNDTQVXtykjmSbo5uDrvS9NOu3SHpAlDE=";

  npmRoot = "ui";

  npmDeps = fetchNpmDeps {
    inherit src;
    sourceRoot = "${src.name}/ui";
    hash = "sha256-qxwTiXLmZnTnmTSBmWPjeFCP7qzvTFN0xXp5lFkWFog=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs
    npmHooks.npmConfigHook
    pkg-config
  ];

  overrideModAttrs = oldAttrs: {
    nativeBuildInputs = lib.filter (drv: drv != npmHooks.npmConfigHook) oldAttrs.nativeBuildInputs;
    preBuild = null;
  };

  buildInputs = [
    taglib
    zlib
  ];
=======
  ui = callPackage ./ui {
    inherit src version;
  };

in

buildGoModule {

  pname = "navidrome";

  inherit src version;

  vendorSha256 = "sha256-C8w/qCts8VqNDTQVXtykjmSbo5uDrvS9NOu3SHpAlDE=";

  nativeBuildInputs = [ makeWrapper pkg-config ];

  buildInputs = [ taglib zlib ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-X github.com/navidrome/navidrome/consts.gitSha=${src.rev}"
    "-X github.com/navidrome/navidrome/consts.gitTag=v${version}"
  ];

  CGO_CFLAGS = lib.optionals stdenv.cc.isGNU [ "-Wno-return-local-addr" ];

<<<<<<< HEAD
  preBuild = ''
    make buildjs
=======
  prePatch = ''
    cp -r ${ui}/* ui/build
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  postFixup = lib.optionalString ffmpegSupport ''
    wrapProgram $out/bin/navidrome \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg-headless ]}
  '';

  passthru = {
<<<<<<< HEAD
    tests.navidrome = nixosTests.navidrome;
    updateScript = nix-update-script { };
=======
    inherit ui;
    tests.navidrome = nixosTests.navidrome;
    updateScript = callPackage ./update.nix {};
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  meta = {
    description = "Navidrome Music Server and Streamer compatible with Subsonic/Airsonic";
    homepage = "https://www.navidrome.org/";
    license = lib.licenses.gpl3Only;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
<<<<<<< HEAD
=======
    platforms = lib.platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with lib.maintainers; [ aciceri squalus ];
    # Broken on Darwin: sandbox-exec: pattern serialization length exceeds maximum (NixOS/nix#4119)
    broken = stdenv.isDarwin;
  };
}
