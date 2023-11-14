{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "fblog";
  version = "4.5.0";

  src = fetchFromGitHub {
    owner = "brocode";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-T0NvcNg2UeUpEf1hjSdoaUkIzCAP29vo6edfeno/oyo=";
  };

  cargoHash = "sha256-3/j/TjsQjXFe+rTfCncjoownXzaUiUBUkCXbFc5RM2o=";

  meta = with lib; {
    description = "A small command-line JSON log viewer";
    homepage = "https://github.com/brocode/fblog";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ figsoda ];
  };
}
