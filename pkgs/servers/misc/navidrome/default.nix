{ callPackage
, buildGoModule
, fetchFromGitHub
, lib
, pkg-config
, stdenv
, ffmpeg-headless
, taglib
, zlib
, makeWrapper
, nixosTests
, ffmpegSupport ? true
}:

let

  version = "0.49.3";

  src = fetchFromGitHub {
    owner = "navidrome";
    repo = "navidrome";
    rev = "v${version}";
    hash = "sha256-JBvY+0QAouEc0im62aVSJ27GAB7jt0qVnYtc6VN2qTA=";
  };

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

  ldflags = [
    "-X github.com/navidrome/navidrome/consts.gitSha=${src.rev}"
    "-X github.com/navidrome/navidrome/consts.gitTag=v${version}"
  ];

  CGO_CFLAGS = lib.optionals stdenv.cc.isGNU [ "-Wno-return-local-addr" ];

  prePatch = ''
    cp -r ${ui}/* ui/build
  '';

  postFixup = lib.optionalString ffmpegSupport ''
    wrapProgram $out/bin/navidrome \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg-headless ]}
  '';

  passthru = {
    inherit ui;
    tests.navidrome = nixosTests.navidrome;
    updateScript = callPackage ./update.nix {};
  };

  meta = {
    description = "Navidrome Music Server and Streamer compatible with Subsonic/Airsonic";
    homepage = "https://www.navidrome.org/";
    license = lib.licenses.gpl3Only;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ aciceri squalus ];
    # Broken on Darwin: sandbox-exec: pattern serialization length exceeds maximum (NixOS/nix#4119)
    broken = stdenv.isDarwin;
  };
}
