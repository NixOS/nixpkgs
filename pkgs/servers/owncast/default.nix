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
  version = "0.1.2";
in buildGoModule {
  pname = "owncast";
  inherit version;
  src = fetchFromGitHub {
    owner = "owncast";
    repo = "owncast";
    rev = "v${version}";
    hash = "sha256-pPBY2PcXe3k9G6kjj/vF5VB6DEmiwKDUrK4VGR4xNzU=";
  };
  vendorHash = "sha256-7HxiZh5X5AZVMiZT6B8DfOy6stJ3+dFEixwJYv5X0dY=";

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
