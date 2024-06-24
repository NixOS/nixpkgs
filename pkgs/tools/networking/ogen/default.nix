{
  pkgs,
  lib,
}:
pkgs.buildGoModule rec {
  pname = "ogen";
  version = "1.0.0";

  src = pkgs.fetchFromGitHub {
    owner = "ogen-go";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-wIcxICfBY5YHVqKHtHd2wzcaDmkzgp7eD6zEvnsRaIU=";
  };

  vendorHash = "sha256-EL8FcAnDMekHBIDRdGqQO4JNESjGC7MQ5aUcDkRqrbg=";
  doCheck = false;

  subPackages = ["cmd/ogen"];

  meta = with lib; {
    description = "OpenAPI v3 code generator for go";
    homepage = "https://github.com/ogen-go/ogen";
  };
}
