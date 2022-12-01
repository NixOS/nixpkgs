{ lib, fetchFromGitHub, rustPlatform }:
rustPlatform.buildRustPackage rec {
  pname = "tuc";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "riquito";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-M2SK6KF8R0WcyFf8eTyYNK5oXj/DfCrAkUZJ3J2LF6U=";
  };

  cargoSha256 = "sha256-MhEIDRC40zQ8mBXxONavtPr87SrueV57HhmIRLIagGA=";

  meta = with lib; {
    description = "When cut doesn't cut it";
    homepage = "https://github.com/riquito/tuc";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dit7ya ];
  };
}
