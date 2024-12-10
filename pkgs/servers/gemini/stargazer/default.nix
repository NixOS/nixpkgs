{
  lib,
  stdenv,
  fetchFromSourcehut,
  rustPlatform,
  installShellFiles,
  scdoc,
  Security,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "stargazer";
  version = "1.2.3";

  src = fetchFromSourcehut {
    owner = "~zethra";
    repo = "stargazer";
    rev = version;
    hash = "sha256-u7usYSopjBeWaZXQLVJrwcdXw16v0w7MD2tjriuZ4Ww=";
  };

  cargoHash = "sha256-ZqUwjWuqs9vB87pqEYm2qdmPBHoCNH1NM9zP5qRV0qE=";

  doCheck = false; # Uses external testing framework that requires network

  passthru.tests = {
    basic-functionality = nixosTests.stargazer;
  };

  nativeBuildInputs = [
    installShellFiles
    scdoc
  ];

  buildInputs = lib.optional stdenv.isDarwin Security;

  postInstall = ''
    scdoc < doc/stargazer.scd  > stargazer.1
    scdoc < doc/stargazer-ini.scd  > stargazer.ini.5
    installManPage stargazer.1
    installManPage stargazer.ini.5
    installShellCompletion completions/stargazer.{bash,zsh,fish}
  '';

  meta = with lib; {
    description = "A fast and easy to use Gemini server";
    mainProgram = "stargazer";
    homepage = "https://sr.ht/~zethra/stargazer/";
    license = licenses.agpl3Plus;
    changelog = "https://git.sr.ht/~zethra/stargazer/refs/${version}";
    maintainers = with maintainers; [ gaykitty ];
  };
}
