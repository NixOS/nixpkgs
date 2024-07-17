{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "beancount-language-server";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "polarmutex";
    repo = "beancount-language-server";
    rev = "v${version}";
    hash = "sha256-C44Z8JaEZvwgocaGjWT3rUAgIBtCRo0xZappMsydR7g=";
  };

  cargoHash = "sha256-NMSNCURSO1iIWHH27FI5Y0q7+Ghds8VSxRGBOp+fH6A=";

  doInstallCheck = true;
  postInstallCheck = ''
    $out/bin/beancount-language-server --help > /dev/null
  '';

  meta = with lib; {
    description = "A Language Server Protocol (LSP) for beancount files";
    mainProgram = "beancount-language-server";
    homepage = "https://github.com/polarmutex/beancount-language-server";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ polarmutex ];
  };
}
