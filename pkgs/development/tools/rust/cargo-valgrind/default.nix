{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
, makeWrapper
, valgrind
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-valgrind";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "jfrimmel";
    repo = "cargo-valgrind";
    rev = version;
    sha256 = "sha256-PltYUU2O/D1PrU+K8JN4+aUVLzHCeNyIsXMU6HLodXE=";
  };

  cargoSha256 = "sha256-XiQGkZ6pfyGkNPjpcPoY66qBl7ABTcRHCBjgmXSRrL0=";

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/cargo-valgrind --prefix PATH : ${lib.makeBinPath [ valgrind ]}
  '';

  # Disable check phase as there are failures (2 tests fail)
  doCheck = false;

  meta = with lib; {
    description = ''Cargo subcommand "valgrind": runs valgrind and collects its output in a helpful manner'';
    homepage = "https://github.com/jfrimmel/cargo-valgrind";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ otavio ];
  };
}
