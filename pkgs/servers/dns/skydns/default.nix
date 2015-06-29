{ lib, goPackages, fetchFromGitHub, etcd }:

with goPackages;

buildGoPackage rec {
  name = "skydns-${version}";
  version = "2.5.0a";

  goPackagePath = "github.com/skynetservices/skydns";

  src = fetchFromGitHub {
    owner = "skynetservices";
    repo = "skydns";
    rev = version;
    sha256 = "18mw8bcz54i4yrv6pc73s3ffcj1vv9cwnn76c9k0bj1mxp1pmdl2";
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
