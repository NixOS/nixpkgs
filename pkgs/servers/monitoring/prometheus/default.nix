{ lib, go, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "prometheus";
  version = "2.14.0";

  goPackagePath = "github.com/prometheus/prometheus";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "prometheus";
    repo = "prometheus";
    sha256 = "0zmxj78h3cnqbhsqab940hyzpim5i9r81b15a57f3dnrrd10p287";
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

  # Disable module-mode, because Go 1.13 automatically enables it if there is
  # go.mod file. Remove after https://github.com/NixOS/nixpkgs/pull/73380
  preCheck = ''
    export GO111MODULE=off
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
