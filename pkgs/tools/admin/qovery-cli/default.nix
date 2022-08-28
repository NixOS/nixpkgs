{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "qovery-cli";
  version = "0.45.0";

  src = fetchFromGitHub {
    owner = "Qovery";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-cJb5Cac7WDhtNL/7uIIvAz7Kum3Ff2g6tmKyTJWvq00=";
  };

  vendorSha256 = "sha256-KHLknBymDAwr7OxS2Ysx6WU5KQ9kmw0bE2Hlp3CBW0c=";

  meta = with lib; {
    description = "Qovery Command Line Interface";
    homepage = "https://github.com/Qovery/qovery-cli";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
