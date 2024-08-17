{ lib
, stdenv
, fetchFromSourcehut
, rustPlatform
, installShellFiles
, scdoc
, Security
, nixosTests
}:

rustPlatform.buildRustPackage rec {
  pname = "stargazer";
  version = "1.2.2";

  src = fetchFromSourcehut {
    owner = "~zethra";
    repo = "stargazer";
    rev = version;
    hash = "sha256-RHiwH+PSic64W9BTLnburykurO2Tes0lGy5droexh+0=";
  };

  cargoHash = "sha256-fzHuztChGtyVTD3wFk6Ke42R0hFA2+HpWcnEbKSYOHY=";

  doCheck = false; # Uses external testing framework that requires network

  passthru.tests = {
    basic-functionality = nixosTests.stargazer;
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
    description = "A fast and easy to use Gemini server";
    mainProgram = "stargazer";
    homepage = "https://sr.ht/~zethra/stargazer/";
    license = licenses.agpl3Plus;
    changelog = "https://git.sr.ht/~zethra/stargazer/refs/${version}";
    maintainers = with maintainers; [ gaykitty ];
  };
}
