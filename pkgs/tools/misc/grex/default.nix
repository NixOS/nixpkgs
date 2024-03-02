{ lib, stdenv
, fetchFromGitHub
, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "grex";
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "pemistahl";
    repo = "grex";
    rev = "v${version}";
    hash = "sha256-ef1eUxeCznIgXLoywwJmnLkTGdW1AmGwCin9DLU9kAs=";
  };

  cargoHash = "sha256-XLH+fS3fwRcWmVOzTjUacV010N37Oofs9Tbixdka1qY=";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/grex --help > /dev/null
  '';

  meta = with lib; {
    description = "A command-line tool for generating regular expressions from user-provided test cases";
    homepage = "https://github.com/pemistahl/grex";
    changelog = "https://github.com/pemistahl/grex/releases/tag/v${version}";
    license = licenses.asl20;
    mainProgram = "grex";
    maintainers = with maintainers; [ SuperSandro2000 mfrw ];
  };
}
