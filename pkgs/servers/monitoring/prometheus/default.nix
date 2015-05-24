{ stdenv, lib, goPackages, fetchFromGitHub, protobuf, vim }:

goPackages.buildGoPackage rec {
   name = "prometheus-${version}";
   version = "0.13.4";
   goPackagePath = "github.com/prometheus/prometheus";
   rev = "612da96c46f0b7ea6cc28a3fc614f14eae0189d0";

   src = fetchFromGitHub {
     inherit rev;
     owner = "prometheus";
     repo = "prometheus";
     sha256 = "1r3pcnxs1cdh18lmqd60r3nh614cw543wzd4slkr2nzr73pn5x4j";
   };

   buildInputs = [
     goPackages.dns
     goPackages.glog
     goPackages.protobuf
     goPackages.goleveldb
     goPackages.net
     goPackages.prometheus.client_golang
     protobuf  # the non-golang package, for protoc
     vim  # for xxd, used in embed-static.sh
   ];

   # Metadata that gets embedded into the binary
   buildFlagsArray = ''
     -ldflags=
         -X main.buildVersion ${version}
         -X main.buildRevision ${builtins.substring 0 6 rev}
         -X main.buildBranch master
         -X main.buildUser nix@nixpkgs
         -X main.buildDate 20150101-00:00:00
         -X main.goVersion ${lib.getVersion goPackages.go}
   '';

   preBuild = ''
   (
     cd "go/src/$goPackagePath"
     protoc --proto_path=./config \
            --go_out=./config/generated/ \
            ./config/config.proto

     cd web
     ${stdenv.shell} ../utility/embed-static.sh static templates \
       | gofmt > blob/files.go
   )
   '';

   meta = with lib; {
     description = "Service monitoring system and time series database";
     homepage = http://prometheus.github.io;
     license = licenses.asl20;
     maintainers = with maintainers; [ benley ];
     platforms = platforms.unix;
   };
}
