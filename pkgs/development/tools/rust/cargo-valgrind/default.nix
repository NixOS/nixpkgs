{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
, makeWrapper
, valgrind
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-valgrind";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "jfrimmel";
    repo = "cargo-valgrind";
    rev = "v${version}";
    sha256 = "sha256-l/1paghG/ARD0JfzNh0xj2UD5kW6FddM8Xrd/FCygYc=";
  };

  cargoSha256 = "sha256-9/kIIZDIsOhUvRT3TyXN5PGFUB+a8m2yXmzBbsPUK28=";

  passthru = {
    updateScript = nix-update-script { };
  };

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/cargo-valgrind --prefix PATH : ${lib.makeBinPath [ valgrind ]}
  '';

  checkFlags = [
    "--skip examples_are_runnable"
    "--skip tests_are_runnable"
  ];

  meta = with lib; {
    description = ''Cargo subcommand "valgrind": runs valgrind and collects its output in a helpful manner'';
    homepage = "https://github.com/jfrimmel/cargo-valgrind";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ otavio matthiasbeyer ];
  };
}
