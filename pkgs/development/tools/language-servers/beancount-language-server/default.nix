{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "beancount-language-server";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "polarmutex";
    repo = "beancount-language-server";
    rev = "v${version}";
    sha256 = "sha256-X3Mun5ZooipUkkcgEOC7ou0d1upABjmMs9MegPBXPyQ=";
  };

  cargoHash = "sha256-OI/MGcFOJHEZJfqCz/+CxHB3VSn6joS7L7FqRYrS4us=";

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

