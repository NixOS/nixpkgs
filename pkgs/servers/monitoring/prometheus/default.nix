{ stdenv, go, buildGoPackage, fetchFromGitHub }:

let
  goPackagePath = "github.com/prometheus/prometheus";

  generic = { version, sha256, ... }@attrs:
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

        doCheck = true;

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
    } // attrs');
in rec {
  prometheus_1 = generic {
    version = "1.8.1";
    sha256 = "07xvpjhhxc0r73qfmkvf94zhv19zv76privw6blg35k5nxcnj7j4";
  };

  prometheus_2 = generic {
    version = "2.2.1";
    sha256 = "1zwxjmj8jh02i4y3i3zrkz7ml66zyhg3ad1npjzf3319mglsp7ch";
  };
}
