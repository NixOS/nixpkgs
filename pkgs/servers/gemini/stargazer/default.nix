{ lib
, stdenv
, fetchFromSourcehut
, rustPlatform
, installShellFiles
, scdoc
, Security
, nixosTests
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "stargazer";
  version = "1.1.3";

  src = fetchFromSourcehut {
    owner = "~zethra";
    repo = "stargazer";
    rev = version;
    hash = "sha256-B+wLkBCwlD10gXY1OCXtJrDCafTW9p9jT0q4wr7O5Yk=";
  };

  cargoHash = "sha256-NS3MnCIGv23bxcGDD0m73ktoKWtPYbnIMqczV8aXqnE=";

  passthru = {
    tests.basic-functionality = nixosTests.stargazer;
    updateScript = nix-update-script { };
  };

  nativeBuildInputs = [ installShellFiles scdoc ];

  buildInputs = lib.optional stdenv.isDarwin Security;

  postInstall = ''
    scdoc < doc/stargazer.scd  > stargazer.1
    scdoc < doc/stargazer-ini.scd  > stargazer.ini.5
    installManPage stargazer.1
    installManPage stargazer.ini.5
    installShellCompletion completions/stargazer.{bash,zsh,fish}
  '';

  meta = with lib; {
    description = "Fast and easy to use Gemini server";
    mainProgram = "stargazer";
    homepage = "https://sr.ht/~zethra/stargazer/";
    license = licenses.agpl3Plus;
    changelog = "https://git.sr.ht/~zethra/stargazer/refs/${version}";
    maintainers = with maintainers; [ gaykitty ];
  };
}
