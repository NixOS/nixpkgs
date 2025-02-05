{
  lib,
  fetchFromSourcehut,
  rustPlatform,
  installShellFiles,
  scdoc,
  nixosTests,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "stargazer";
  version = "1.3.1";

  src = fetchFromSourcehut {
    owner = "~zethra";
    repo = "stargazer";
    rev = version;
    hash = "sha256-0vbQDHuLrgrsWiOb2hb6lYylJm5o/wOzoDIw85H8Eh0=";
  };

  cargoHash = "sha256-EtRJsm6jo0fSEN9s0cS4IBWV/NnuUeDTa/x1utbh85k=";

  passthru = {
    tests.basic-functionality = nixosTests.stargazer;
    updateScript = nix-update-script { };
  };

  nativeBuildInputs = [
    installShellFiles
    scdoc
  ];

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
