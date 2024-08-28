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
  version = "1.3.0";

  src = fetchFromSourcehut {
    owner = "~zethra";
    repo = "stargazer";
    rev = version;
    hash = "sha256-Qzg9sCdD29FghHMY6obeVHMD0SRvzi9J6MhEUvcQgbE=";
  };

  cargoHash = "sha256-SQzYEFdSUC1znukot3G3WoOsQGlYP7ICXpoy/w9eO8A=";

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
