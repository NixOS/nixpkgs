{ stdenv, go, buildGoPackage, fetchFromGitHub }:

let
  goPackagePath = "github.com/prometheus/prometheus";
in rec {
  buildPrometheus = { version, sha256, doCheck ? true, ... }@attrs:
    let attrs' = builtins.removeAttrs attrs ["version" "sha256"]; in
      buildGoPackage ({
        name = "prometheus-${version}";

        inherit goPackagePath;

        src = fetchFromGitHub {
          rev = "v${version}";
          owner = "prometheus";
          repo = "prometheus";
          inherit sha256;
        };

        buildFlagsArray = let t = "${goPackagePath}/vendor/github.com/prometheus/common/version"; in ''
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
    } // attrs');

  prometheus_1 = buildPrometheus {
    version = "1.8.2";
    sha256 = "088flpg3qgnj9afl9vbaa19v2s1d21yxy38nrlv5m7cxwy2pi5pv";
  };

  prometheus_2 = buildPrometheus {
    version = "2.10.0";
    sha256 = "00597rf4cg20clr3g3ql3nf47r8qij2xspcpp8y8mpxm2b60zjnq";
  };
}
