{ lib, rustPlatform, fetchFromGitHub, fetchpatch }:

rustPlatform.buildRustPackage rec {
  pname = "rnix-hashes";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "numtide";
    repo = pname;
    rev = "v${version}";
    sha256 = "SzHyG5cEjaaPjTkn8puht6snjHMl8DtorOGDjxakJfA=";
  };

  patches = [
    # fix test failure
    (fetchpatch {
      url = "https://github.com/numtide/rnix-hashes/commit/62ab96cfd1efeade7d98efd9829eae8677bac9cc.patch";
      sha256 = "sha256-oE2fBt20FmO2cEUGivu2mKo3z6rbhVLXSF8SRvhibFs=";
    })
  ];

  cargoSha256 = "sha256-p6W9NtOKzVViyFq5SQvnIsik7S3mqUqxI/05OiC+P+Q=";

  meta = with lib; {
    description = "Nix Hash Converter";
    mainProgram = "rnix-hashes";
    homepage = "https://github.com/numtide/rnix-hashes";
    license = licenses.asl20;
    maintainers = with maintainers; [ rizary SuperSandro2000 ];
  };
}
