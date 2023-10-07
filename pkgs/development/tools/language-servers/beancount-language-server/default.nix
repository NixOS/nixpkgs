{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "beancount-language-server";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "polarmutex";
    repo = "beancount-language-server";
    rev = "v${version}";
    hash = "sha256-9IkbEOG6xcmpowsLj/RHnMFGQxh02JMQsTVli4hvs/M=";
  };

  cargoHash = "sha256-qhN2//hhCaKpm0HAiUL/CfdrtvAXgR34vXBECB8UDxE=";

  doInstallCheck = true;
  postInstallCheck = ''
    $out/bin/beancount-language-server --help > /dev/null
  '';

  meta = with lib; {
    description = "A Language Server Protocol (LSP) for beancount files";
    homepage = "https://github.com/polarmutex/beancount-language-server";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ polarmutex ];
  };
}
