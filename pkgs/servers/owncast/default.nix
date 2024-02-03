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
  version = "0.1.1";
in buildGoModule {
  pname = "owncast";
  inherit version;
  src = fetchFromGitHub {
    owner = "owncast";
    repo = "owncast";
    rev = "v${version}";
    hash = "sha256-nBTuvVVnFlC75p8bRCN+lNl9fExBZrsLEesvXWwNlAQ=";
  };
  vendorHash = "sha256-yjy5bDJjWk7UotBVqvVFiGx8mpfhpqMTxoQm/eWHcw4=";

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
  };

}
