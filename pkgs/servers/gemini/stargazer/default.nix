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
  version = "1.1.0";

  src = fetchFromSourcehut {
    owner = "~zethra";
    repo = "stargazer";
    rev = version;
    hash = "sha256-c0gKvVaMiUOGHlPmtaW6it8J9MusQY7BA/5F9I3ysMc=";
  };

  cargoHash = "sha256-8VrEZZNSFLAjUagsiRApvjiXusBHLLn1O/+QKtQY4wg=";

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
    homepage = "https://sr.ht/~zethra/stargazer/";
    license = licenses.agpl3Plus;
    changelog = "https://git.sr.ht/~zethra/stargazer/refs/${version}";
    maintainers = with maintainers; [ gaykitty ];
  };
}
