{ stdenv, lib, goPackages, fetchFromGitHub, protobuf, vim }:

with goPackages;

buildGoPackage rec {
   name = "prometheus-${version}";
   version = "0.10.0";
   goPackagePath = "github.com/prometheus/prometheus";
   rev = "f5a0f7fa185dae2c772a5847a7aac9ba33b545f9";

   src = fetchFromGitHub {
     inherit rev;
     owner = "prometheus";
     repo = "prometheus";
     sha256 = "1wagmr4bca8fbvi48n9p4hdnx1m4chyaa1bzman6dhqfmkiikf5q";
   };

   buildInputs = [
     dns glog goleveldb prometheus.client_golang
     goPackages.protobuf
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
         -X main.goVersion ${lib.getVersion go}
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
