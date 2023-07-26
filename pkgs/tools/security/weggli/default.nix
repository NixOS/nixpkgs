{ lib
, rustPlatform
, fetchFromGitHub
, testers
, weggli
}:

rustPlatform.buildRustPackage rec {
  pname = "weggli";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "weggli-rs";
    repo = "weggli";
    rev = "v${version}";
    hash = "sha256-6XSedsTUjcZzFXaNitsXlUBpxC6TYVMCB+AfH3x7c5E=";
  };

  cargoSha256 = "sha256-Cj/m4GRaqI/lHYFruj047B7FdGoVl/wC8I2o1dzhOTs=";

  passthru.tests.version = testers.testVersion {
    package = weggli;
    command = "weggli -V";
    version = "weggli ${version}";
  };

  meta = with lib; {
    description = "Weggli is a fast and robust semantic search tool for C and C++ codebases";
    homepage = "https://github.com/weggli-rs/weggli";
    changelog = "https://github.com/weggli-rs/weggli/releases/tag/v${version}";
    mainProgram = "weggli";
    license = licenses.asl20;
    maintainers = with maintainers; [ arturcygan mfrw ];
  };
}
