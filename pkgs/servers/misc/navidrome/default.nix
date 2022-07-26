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

  version = "0.47.5";

  src = fetchFromGitHub {
    owner = "navidrome";
    repo = "navidrome";
    rev = "v${version}";
    hash = "sha256-gTvJI+brdEpdpbEcdQycqw15seI+k5dMDVrjY3v6i14=";
  };

  ui = callPackage ./ui {
    inherit src version;
  };

in

buildGoModule {

  pname = "navidrome";

  inherit src version;

  vendorSha256 = "sha256-xMAxGbq2VSXkF9R9hxB9EEk2CnqsRxg2Nmt7zyXohJI=";

  nativeBuildInputs = [ makeWrapper pkg-config ];

  buildInputs = [ taglib zlib ];

  CGO_CFLAGS = [ "-Wno-return-local-addr" ];

  prePatch = ''
    cp -r ${ui}/* ui/build
  '';

  postFixup = lib.optionalString ffmpegSupport ''
    wrapProgram $out/bin/navidrome \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg ]}
  '';

  doCheck = false;

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
