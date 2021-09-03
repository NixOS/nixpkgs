{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "choose";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "theryangeary";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HYwlAgFKbi6or2eblERdMMjJOJdtt2FCQECUg3MzO8E=";
  };

  cargoSha256 = "sha256-55/B+LxdbekfaKKyng0lUCU3QnqL34M+QnLUxaPqkqI=";

  meta = with lib; {
    description = "A human-friendly and fast alternative to cut and (sometimes) awk";
    homepage = "https://github.com/theryangeary/choose";
    license = licenses.gpl3;
    maintainers = with maintainers; [ sohalt ];
  };
}
