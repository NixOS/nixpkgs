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
<<<<<<< HEAD
    hash = "sha256-66R5XxrNQ1YMMQicw0VCF/XzRo//5Gqdjlher/uMoTE=";
  };

  vendorHash = "sha256-rhOjBMCyfirEI/apL3ObHfKZeuNPGSt84R9lwCbRIpg=";
=======
    sha256 = "0cd1ikxsypjqisfnmr7zix3g7x8p892w77086465chyd39gpk97b";
  };

  vendorSha256 = "1612s4kc0r8zw5y2n6agwdx9kwhxkdrjzagn4g22lzmjq02a64xf";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://aswinkarthik.github.io/csvdiff/";
    description = "A fast diff tool for comparing csv files";
    license = licenses.mit;
    maintainers = with maintainers; [ turion ];
  };
}
