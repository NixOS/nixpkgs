{ lib
, rustPlatform
, fetchFromGitHub
, gitUpdater
, common-updater-scripts
, makeWrapper
, rr
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-rr";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "danielzfranklin";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lQS+bp1u79iO8WGrkZSFEuonr1eYjxIQYhUvM/kBao4";
  };

  cargoSha256 = "sha256-PdKqWMxTtBJbNqITs3IjNcpijXy6MHitEY4jDp4jZro=";

  passthru = {
    updateScript = gitUpdater {
      inherit pname version;
      rev-prefix = "v";
    };
  };

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/cargo-rr --prefix PATH : ${lib.makeBinPath [ rr ]}
  '';

  meta = with lib; {
    description = "Cargo subcommand \"rr\": a light wrapper around rr, the time-travelling debugger";
    homepage = "https://github.com/danielzfranklin/cargo-rr";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ otavio ];
  };
}
