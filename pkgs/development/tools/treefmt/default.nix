{ lib, rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
  pname = "treefmt";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "numtide";
    repo = "treefmt";
    rev = "v${version}";
    sha256 = "sha256-hnrMy8iYoaeWxZlhO9L1kQW3OgL6jHL1MxJpbNFLHZk=";
  };

  cargoSha256 = "sha256-O7Ma6+Vniil5hIDd5JCWecTvkAjq7wMuuyfrzePDDq4=";

  meta = {
    description = "one CLI to format the code tree";
    homepage = "https://github.com/numtide/treefmt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zimbatm ];
  };
}
