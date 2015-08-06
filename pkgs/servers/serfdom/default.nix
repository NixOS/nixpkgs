{ lib, goPackages, fetchFromGitHub }:

with goPackages;

buildGoPackage rec {
  version = "0.6.4";
  name = "serfdom-${version}";
  goPackagePath = "github.com/hashicorp/serf";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "serf";
    rev = "v${version}";
    sha256 = "1fhz8wrvsmgaky22n255w9hkyfph2n45c47ivdyzrrxisg5j2438";
  };

  buildInputs = [ cli mapstructure memberlist_v2 logutils go-syslog mdns columnize circbuf ugorji.go ];

  dontInstallSrc = true;

  meta = with lib; {
    description = "A service discovery and orchestration tool that is decentralized, highly available, and fault tolerant";
    homepage = http://www.serfdom.io/;
    license = licenses.mpl20;
    maintainers = with maintainers; [ msackman cstrahan ];
    platforms = platforms.unix;
  };
}
