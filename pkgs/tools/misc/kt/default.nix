{ stdenv, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  name = "kt-${version}";
  version = "12.1.0";

  src = fetchFromGitHub {
    owner = "fgeller";
    repo = "kt";
    rev = "v${version}";
    sha256 = "014q39bg88vg1xdq1bz6wj982zb148sip3a42hbrinh8qj41y4yg";
  };

  goPackagePath = "github.com/fgeller/kt";

  meta = with stdenv.lib; {
    description = "Kafka command line tool";
    homepage = https://github.com/fgeller/kt;
    maintainers = with maintainers; [ utdemir ];
    platforms = with platforms; unix;
    license = licenses.mit;
  };
}
