{ lib, fetchFromGitHub, rustPlatform }:
rustPlatform.buildRustPackage rec {
  pname = "tuc";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "riquito";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-83tS0sYqQqGQVXFBQ/mIDxL9QKqPjAM48vTXA8NKdtE=";
  };

  cargoHash = "sha256-ka6h60ettSsho7QnWmpWrEPEyHIIyTVSW2r1Hk132CY=";

  meta = with lib; {
    description = "When cut doesn't cut it";
    homepage = "https://github.com/riquito/tuc";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dit7ya ];
  };
}
