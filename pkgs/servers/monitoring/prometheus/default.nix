{ stdenv, go, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "prometheus-${version}";
  version = "1.8.1";
  rev = "v${version}";

  goPackagePath = "github.com/prometheus/prometheus";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "prometheus";
    sha256 = "07xvpjhhxc0r73qfmkvf94zhv19zv76privw6blg35k5nxcnj7j4";
  };

  docheck = true;

  buildFlagsArray = let t = "${goPackagePath}/version"; in ''
    -ldflags=
       -X ${t}.Version=${version}
       -X ${t}.Revision=unknown
       -X ${t}.Branch=unknown
       -X ${t}.BuildUser=nix@nixpkgs
       -X ${t}.BuildDate=unknown
       -X ${t}.GoVersion=${stdenv.lib.getVersion go}
  '';

  preInstall = ''
    mkdir -p "$bin/share/doc/prometheus" "$bin/etc/prometheus"
    cp -a $src/documentation/* $bin/share/doc/prometheus
    cp -a $src/console_libraries $src/consoles $bin/etc/prometheus
  '';

  meta = with stdenv.lib; {
    description = "Service monitoring system and time series database";
    homepage = https://prometheus.io;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley fpletz ];
    platforms = platforms.unix;
  };
}
