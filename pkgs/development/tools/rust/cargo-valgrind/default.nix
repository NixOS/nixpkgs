{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
, makeWrapper
, valgrind
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-valgrind";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "jfrimmel";
    repo = "cargo-valgrind";
    rev = "v${version}";
    sha256 = "sha256-FCz15kMSKckifYWSTMGqJbRpZ8X/AM5dSw46dg8ERcY=";
  };

  cargoSha256 = "sha256-csSUe2qUIN2xKOMHWyM56FZyCwKPdfAI0NrFiDOtRiE=";

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
    maintainers = with maintainers; [ otavio ];
  };
}
