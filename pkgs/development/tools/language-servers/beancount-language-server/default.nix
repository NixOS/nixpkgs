{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "beancount-language-server";
  version = "1.3.5";

  src = fetchFromGitHub {
    owner = "polarmutex";
    repo = "beancount-language-server";
    rev = "v${version}";
    hash = "sha256-Z8Gc3QbnFGzF1mNjlbazz7OiDpQxY3HcaBKd32XjQCY=";
  };

  cargoHash = "sha256-WMrh4toFqd+G30ZZxC+kT/Q07gn+3p80oKECASD48wc=";

  doInstallCheck = true;
  postInstallCheck = ''
    $out/bin/beancount-language-server --help > /dev/null
  '';

  meta = with lib; {
    description = "Language Server Protocol (LSP) for beancount files";
    mainProgram = "beancount-language-server";
    homepage = "https://github.com/polarmutex/beancount-language-server";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ polarmutex ];
  };
}
