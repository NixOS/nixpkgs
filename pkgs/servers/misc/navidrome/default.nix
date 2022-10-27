{ callPackage
, buildGoModule
, fetchFromGitHub
, lib
, pkg-config
, stdenv
, ffmpeg
, taglib
, zlib
, makeWrapper
, nixosTests
, ffmpegSupport ? true
}:

let

  version = "0.48.0";

  src = fetchFromGitHub {
    owner = "navidrome";
    repo = "navidrome";
    rev = "v${version}";
    hash = "sha256-FO2Vl3LeajvZ8CLtnsOSLXr//gaOWPbMthj70RHxp+Q=";
  };

  ui = callPackage ./ui {
    inherit src version;
  };

in

buildGoModule {

  pname = "navidrome";

  inherit src version;

  vendorSha256 = "sha256-LPoM5RFHfTTWZtlxc59hly12zzrY8wjXGZ6xW2teOFM=";

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
      --prefix PATH : ${lib.makeBinPath [ ffmpeg ]}
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
  };
}
