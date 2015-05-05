{ lib, goPackages, fetchFromGitHub, etcd }:

with goPackages;

buildGoPackage rec {
  name = "skydns-${version}";
  version = "2.1.0a";

  goPackagePath = "github.com/skynetservices/skydns";

  src = fetchFromGitHub {
    owner = "skynetservices";
    repo = "skydns";
    rev = "f5141ee69309fb4c542d5a0b50fc7616370c5c06";
    sha256 = "1bnc9r22kwvmn1bgz7zaidkjqm7pmw99bn5n87r76vcrd7n2a9pd";
  };

  buildInputs = with goPackages; [ go-etcd rcrowley.go-metrics influxdb-go go-systemd go-log dns stathat osext etcd ];
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
