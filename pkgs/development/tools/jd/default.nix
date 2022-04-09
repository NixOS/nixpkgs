{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "jd";
  version = "0.3.1";

  goPackagePath = "github.com/tidwall/jd";

  src = fetchFromGitHub {
    owner = "tidwall";
    repo = "jd";
    rev = "2729b5af166cfd72bd953ef8959b456c4db940fc";
    sha256 = "sha256-sNiKPlpnASJs0gKLpyfRxQjZRN9JaCvPoQ0gd9GYRDY=";
  };

  meta = with lib; {
    description = "Interactive JSON Editor";
    license = licenses.mit;
    maintainers = [ maintainers.np ];
  };
}
