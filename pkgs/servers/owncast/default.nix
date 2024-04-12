{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
, bash
, which
, ffmpeg
, makeBinaryWrapper
}:

let
  version = "0.1.3";
in buildGoModule {
  pname = "owncast";
  inherit version;
  src = fetchFromGitHub {
    owner = "owncast";
    repo = "owncast";
    rev = "v${version}";
    hash = "sha256-VoItAV/8hzrqj4bIgMum9Drr/kAafH63vXw3GO6nSOc=";
  };
  vendorHash = "sha256-JitvKfCLSravW5WRE0QllJTrRPLaaBg1GxJi3kmtiIU=";

  propagatedBuildInputs = [ ffmpeg ];

  nativeBuildInputs = [ makeBinaryWrapper ];

  postInstall = ''
    wrapProgram $out/bin/owncast \
      --prefix PATH : ${lib.makeBinPath [ bash which ffmpeg ]}
  '';

  installCheckPhase = ''
    runHook preCheck
    $out/bin/owncast --help
    runHook postCheck
  '';

  passthru.tests.owncast = nixosTests.testOwncast;

  meta = with lib; {
    description = "self-hosted video live streaming solution";
    homepage = "https://owncast.online";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ MayNiklas ];
    mainProgram = "owncast";
  };

}
