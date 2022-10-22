{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "jwx";
  version = "2.0.6";

  src = fetchFromGitHub {
    owner = "lestrrat-go";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-7X+UeguaWk7+IQ2/PgoFZR7OKpOTzgT/mo8k4eSl53A=";
  };

  vendorSha256 = "sha256-XZk/cwbfg05RkUFMs+AHTfEZiEvqYYoPoSVZVFM967g=";

  sourceRoot = "source/cmd/jwx";

  meta = with lib; {
    description = " Implementation of various JWx (Javascript Object Signing and Encryption/JOSE) technologies";
    homepage = "https://github.com/lestrrat-go/jwx";
    license = licenses.mit;
    maintainers = with maintainers; [ arianvp flokli ];
  };
}
