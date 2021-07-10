{lib,  stdenv, fetchgit, pkgs }:

stdenv.mkDerivation rec {

  name = "protoc-gen-grpc-web";

  src = fetchgit {
    url = "https://github.com/grpc/grpc-web";
    rev = "35c16a9e4e113b65966e159dc879bc452c00526c";
    sha256 = "161f0p3i143qyg52mp4g8man8f4xd0bdn4kr5r50lgcjqgklvi8a";
  };

  doCheck = true;
  buildInputs = with pkgs; [ protobuf ];
  
  buildPhase = ''
    make plugin
  '';

  installPhase = ''
    mkdir -p $out/bin
    cd javascript/net/grpc/web && install protoc-gen-grpc-web $out/bin
  '';
  

  meta = with lib; {
    description = "A javascript code generator for gRPC Web";
    homepage = "https://github.com/grpc/grpc-web";
    maintainers = with lib.maintainers; [ kaiserkarel ];
    license = licenses.asl20;
  };
}
