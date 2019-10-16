{ lib, go, buildGoPackage, fetchFromGitHub }:

let
  goPackagePath = "github.com/prometheus/prometheus";
in
buildGoPackage rec {
  pname = "prometheus";
  version = "2.13.0";

  inherit goPackagePath;

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "prometheus";
    repo = "prometheus";
    sha256 = "08fmicgrv9b37qapmqjbif19c9181mpp7abd2yrpc3xpyjd3h687";
  };

  buildFlagsArray = let
    t = "${goPackagePath}/vendor/github.com/prometheus/common/version";
  in ''
    -ldflags=
       -X ${t}.Version=${version}
       -X ${t}.Revision=unknown
       -X ${t}.Branch=unknown
       -X ${t}.BuildUser=nix@nixpkgs
       -X ${t}.BuildDate=unknown
       -X ${t}.GoVersion=${lib.getVersion go}
  '';

  preInstall = ''
    mkdir -p "$bin/share/doc/prometheus" "$bin/etc/prometheus"
    cp -a $src/documentation/* $bin/share/doc/prometheus
    cp -a $src/console_libraries $src/consoles $bin/etc/prometheus
  '';

  doCheck = true;

  meta = with lib; {
    description = "Service monitoring system and time series database";
    homepage = "https://prometheus.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley fpletz globin willibutz ];
    platforms = platforms.unix;
  };
}
