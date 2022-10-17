{ lib
, rustPlatform
, fetchCrate
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "xq";
  version = "0.2.39";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-eyQ38Ld/sVI5vvQRohGfu+cXNtS3nTOBwxiO9BqjxhM=";
  };

  cargoSha256 = "sha256-LajK6OaH6uwnwXvOSJCY/oTtAd2+mcFTWghxC5mVAjQ=";

  meta = with lib; {
    description = "Pure rust implementation of jq";
    homepage = "https://github.com/MiSawa/xq";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
  };
}
