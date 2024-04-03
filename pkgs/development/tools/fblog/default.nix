{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "fblog";
  version = "4.9.0";

  src = fetchFromGitHub {
    owner = "brocode";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-9v8bn68anWB0vkRIixa6YvNl54z6X8u+MyYs38Zgc5A=";
  };

  cargoHash = "sha256-tXBXI0tlCdfxKscR4Vfw4okJw+jW3EqPz4Rp6xeCdIQ=";

  meta = with lib; {
    description = "A small command-line JSON log viewer";
    mainProgram = "fblog";
    homepage = "https://github.com/brocode/fblog";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ figsoda ];
  };
}
