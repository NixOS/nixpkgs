{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "beancount-language-server";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "polarmutex";
    repo = "beancount-language-server";
    rev = "v${version}";
    sha256 = "sha256-CkwNxamkErRo3svJNth2F8NSqlJNX+1S/srKu6Z+mX4=";
  };

  cargoSha256 = "sha256-NTUs9ADTn+KoE08FikRHrdptZkrUqnjVIlcr8RtDvic=";

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

