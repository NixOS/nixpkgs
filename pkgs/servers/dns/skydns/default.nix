{ lib, goPackages, fetchFromGitHub, etcd }:

with goPackages;

buildGoPackage rec {
  name = "skydns-${version}";
  version = "2.5.2b";

  goPackagePath = "github.com/skynetservices/skydns";

  src = fetchFromGitHub {
    owner = "skynetservices";
    repo = "skydns";
    rev = version;
    sha256 = "01vac6bd71wky5jbd5k4a0x665bjn1cpmw7p655jrdcn5757c2lv";
  };

  buildInputs = with goPackages; [ go-etcd rcrowley.go-metrics influxdb go-systemd go-log dns stathat osext etcd ];
  dontInstallSrc = true;

  subPackages = [ "." ];

  meta = with lib; {
    description = "DNS service discovery for etcd";
    homepage = https://github.com/skynetservices/skydns;
    license = licenses.mit;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.unix;
  };
}
