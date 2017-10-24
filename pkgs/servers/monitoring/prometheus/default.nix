{ stdenv, lib, go, buildGoPackage, fetchFromGitHub }:

with lib;

let
  genericBuild = _: { version, sha256, doCheck ? true }: buildGoPackage rec {
    name = "prometheus-${version}";
    inherit version;
    rev = "v${version}";

    goPackagePath = "github.com/prometheus/prometheus";

    src = fetchFromGitHub {
      inherit rev sha256;
      owner = "prometheus";
      repo = "prometheus";
    };

    inherit doCheck;

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
  };

in mapAttrs genericBuild {

  prometheus1 = {
    version = "1.8.1";
    sha256 = "07xvpjhhxc0r73qfmkvf94zhv19zv76privw6blg35k5nxcnj7j4";
  };

  prometheus2 = {
    version = "2.0.0-rc.1";
    sha256 = "0i44gsb6lhxkgjb3i489h1939c44szj3dslmmf910dm21497fapz";
    # Tests need lots of diskspace
    doCheck = false;
  };

}
