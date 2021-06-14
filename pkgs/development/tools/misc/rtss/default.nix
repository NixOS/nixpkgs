{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "rtss";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "Freaky";
    repo = pname;
    rev = "v${version}";
    sha256 = "1936w161mkbcwicrxn51b42pgir5yjiw85s74lbfq70nddw18nyn";
  };

  cargoSha256 = "1b1xiaaxbw6y80pkzd594dikm372l1mmymf1wn2acmlz979nmas8";

  meta = with lib; {
    description = "Annotate output with relative durations between lines";
    homepage = "https://github.com/Freaky/rtss";
    license = licenses.mit;
    maintainers = with maintainers; [ djanatyn ];
  };
}
