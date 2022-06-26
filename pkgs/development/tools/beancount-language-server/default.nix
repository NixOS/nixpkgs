{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "beancount-language-server";
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "polarmutex";
    repo = "beancount-language-server";
    rev = "v${version}";
    sha256 = "sha256-AbljduMz4mz5InsHKCq0K6i9F/lBgvdy0+W8aclr0R0=";
  };

  cargoSha256 = "sha256-jrxVMGJk4o9aROtFZBc8G/HP5xm9MjVyewww1DzrRdM=";

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

