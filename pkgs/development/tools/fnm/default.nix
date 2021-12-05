{ lib, stdenv, fetchFromGitHub, rustPlatform, installShellFiles, DiskArbitration
, Foundation, Security }:

rustPlatform.buildRustPackage rec {
  pname = "fnm";
  version = "1.28.1";

  src = fetchFromGitHub {
    owner = "Schniz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-EH3M5wg+BfTZLvch4jL7AGWwywoSxo+8marzdUgAitg=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs =
    lib.optionals stdenv.isDarwin [ DiskArbitration Foundation Security ];

  cargoSha256 = "sha256-Mq1SzAZa05tglcwW6fvT1khVwqA3hRzFjouWLNMWgOk=";

  doCheck = false;

  postInstall = ''
    installShellCompletion --cmd fnm \
      --bash <($out/bin/fnm completions --shell bash) \
      --fish <($out/bin/fnm completions --shell fish) \
      --zsh <($out/bin/fnm completions --shell zsh)
  '';

  meta = with lib; {
    description = "Fast and simple Node.js version manager";
    homepage = "https://github.com/Schniz/fnm";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ kidonng ];
  };
}
