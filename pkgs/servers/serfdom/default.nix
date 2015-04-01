{ lib, goPackages, fetchFromGitHub }:

with goPackages;

buildGoPackage rec {
  version = "0.6.3";
  name = "serfdom-${version}";
  goPackagePath = "github.com/hashicorp/serf";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "serf";
    rev = "v${version}";
    sha256 = "0ck77ji28bvm4ahzxyyi4sm17c3fxc16k0k5mihl1nlkgdd73m8y";
  };

  buildInputs = [ cli mapstructure memberlist logutils go-syslog mdns columnize circbuf ];

  dontInstallSrc = true;

  meta = with lib; {
    description = "A service discovery and orchestration tool that is decentralized, highly available, and fault tolerant";
    homepage = http://www.serfdom.io/;
    license = licenses.mpl20;
    maintainers = with maintainers; [ msackman cstrahan ];
    platforms = platforms.unix;
  };
}
