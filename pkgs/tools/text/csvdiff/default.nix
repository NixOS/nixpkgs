{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "csvdiff";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "aswinkarthik";
    repo = "csvdiff";
    rev = "v${version}";
    sha256 = "0cd1ikxsypjqisfnmr7zix3g7x8p892w77086465chyd39gpk97b";
  };

  vendorSha256 = "1612s4kc0r8zw5y2n6agwdx9kwhxkdrjzagn4g22lzmjq02a64xf";

  meta = with lib; {
    homepage = "https://aswinkarthik.github.io/csvdiff/";
    description = "A fast diff tool for comparing csv files";
    license = licenses.mit;
    maintainers = with maintainers; [ turion ];
  };
}
