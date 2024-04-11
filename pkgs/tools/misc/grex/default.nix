{ lib, stdenv
, fetchFromGitHub
, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "grex";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "pemistahl";
    repo = "grex";
    rev = "v${version}";
    hash = "sha256-Ut2H2H66XN1+wHpYivnuhil21lbd7bwIcIcMyIimdis=";
  };

  cargoHash = "sha256-ZRE1vKgi0/UtSe2bdN0BLdtDfAauTfwcqOcl3y63fAA=";

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
