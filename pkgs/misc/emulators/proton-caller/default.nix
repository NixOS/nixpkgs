{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "proton-caller";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "caverym";
    repo = pname;
    rev = version;
    sha256 = "1rj0f8jzmrvj6gz1rcdjmxdqk2i5cxhz9ji4217kwyb6h1h0jmdk";
  };

  cargoSha256 = "165kzza1m8h37y1ir0d0hp0z645h4ihkyj83fii69f18gk47r3kg";

  meta = with lib; {
    description = "Run Windows programs with Proton";
    changelog = "https://github.com/caverym/proton-caller/releases/tag/${version}";
    homepage = "https://github.com/caverym/proton-caller";
    license = licenses.mit;
    maintainers = with maintainers; [ kho-dialga ];
  };
}
