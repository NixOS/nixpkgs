{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "fblog";
  version = "4.13.0";

  src = fetchFromGitHub {
    owner = "brocode";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-MfE1IwJ8n9wFrs3l33h3aeG8t8SVxRG4VZGpgVrjTW8=";
  };

  cargoHash = "sha256-6joXL/eHipyBVNFz0zSH2UldZ1jYUFeOxB1weNAA9b4=";

  meta = with lib; {
    description = "Small command-line JSON log viewer";
    mainProgram = "fblog";
    homepage = "https://github.com/brocode/fblog";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ figsoda ];
  };
}
