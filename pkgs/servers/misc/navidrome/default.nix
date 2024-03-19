{ buildGoModule
, buildPackages
, fetchFromGitHub
, fetchNpmDeps
, lib
, nodejs
, npmHooks
, pkg-config
, stdenv
, ffmpeg-headless
, taglib
, zlib
, makeWrapper
, nixosTests
, nix-update-script
, ffmpegSupport ? true
}:

buildGoModule rec {
  pname = "navidrome";
  version = "0.51.1";

  src = fetchFromGitHub {
    owner = "navidrome";
    repo = "navidrome";
    rev = "v${version}";
    hash = "sha256-6IYQrSWqrvYz2tDlk14UaX36bdXN0DbF7ynaa3Qboa4=";
  };

  vendorHash = "sha256-Q95OchWkxd/EmG7Vu0e/dge9nOIrGmcTgjGL5dBvEKA=";

  npmRoot = "ui";

  npmDeps = fetchNpmDeps {
    inherit src;
    sourceRoot = "${src.name}/ui";
    hash = "sha256-LrLswdt6RA55FQE/YWHNwtjxljjlCNSTLWJNqy1ohKo=";
  };

  nativeBuildInputs = [
    buildPackages.makeWrapper
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

  ldflags = [
    "-X github.com/navidrome/navidrome/consts.gitSha=${src.rev}"
    "-X github.com/navidrome/navidrome/consts.gitTag=v${version}"
  ];

  CGO_CFLAGS = lib.optionals stdenv.cc.isGNU [ "-Wno-return-local-addr" ];

  preBuild = ''
    make buildjs
  '';

  postFixup = lib.optionalString ffmpegSupport ''
    wrapProgram $out/bin/navidrome \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg-headless ]}
  '';

  passthru = {
    tests.navidrome = nixosTests.navidrome;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Navidrome Music Server and Streamer compatible with Subsonic/Airsonic";
    mainProgram = "navidrome";
    homepage = "https://www.navidrome.org/";
    license = lib.licenses.gpl3Only;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    maintainers = with lib.maintainers; [ aciceri squalus ];
    # Broken on Darwin: sandbox-exec: pattern serialization length exceeds maximum (NixOS/nix#4119)
    broken = stdenv.isDarwin;
  };
}
