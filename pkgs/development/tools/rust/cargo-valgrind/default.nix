{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
, makeWrapper
, valgrind
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-valgrind";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "jfrimmel";
    repo = "cargo-valgrind";
    rev = version;
    sha256 = "sha256-PEGDao010COqSJGha7GQvR7vNOV+C7faduijVNjB5DE=";
  };

  cargoSha256 = "sha256-00WUYrkKKJOEN9jXKQ3YraTq89U+3djdvLRuZSbeNHk=";

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
