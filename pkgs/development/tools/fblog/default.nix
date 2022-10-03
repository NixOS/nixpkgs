{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "fblog";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "brocode";
    repo = pname;
    rev = "v${version}";
    sha256 = "1lj0cv1rmcqg36rxnnjh1dazn0sdggfc9kigjg3id6h0y8k7d9b3";
  };

  cargoSha256 = "sha256-xHvnxRPxe09EmxUK9j7+V2AA1xJFP3ibwbkSs3FBgcw=";

  meta = with lib; {
    description = "A small command-line JSON log viewer";
    homepage = "https://github.com/brocode/fblog";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ figsoda ];
  };
}
