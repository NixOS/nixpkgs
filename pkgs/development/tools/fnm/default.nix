{ lib, stdenv, fetchFromGitHub, rustPlatform, installShellFiles, Security }:

rustPlatform.buildRustPackage rec {
  pname = "fnm";
  version = "1.26.0";

  src = fetchFromGitHub {
    owner = "Schniz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-wKtgMUt7QquT6mS3AI+XrZqbJOZxj6jlJi+7uC9w7xU=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  cargoSha256 = "sha256-TMhhCVVFTanKdbDp7L3ZaiNohWo5a/jFbQjdRiBlCkk=";

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
