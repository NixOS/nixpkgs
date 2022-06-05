{ lib, buildGoPackage, fetchFromGitHub, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  pname = "waitron";
  version = "unstable-2020-01-24";

  goPackagePath = "github.com/ns1/waitron";

  src = fetchFromGitHub {
    owner = "ns1";
    repo = "waitron";
    rev = "c96833619cbb0cf2bc71b1d7b534101e139cc6e6";
    sha256 = "sha256-ZkGhEOckIOYGb6Yjr4I4e9cjAHDfksRwHW+zgOMZ/FE=";
  };

  patches = [
    ./staticfiles-directory.patch
  ];

  goDeps = ./deps.nix;

  meta = {
    description = "A tool to manage network booting of machines";
    homepage = "https://github.com/ns1/waitron";
    license =  lib.licenses.asl20;
    maintainers = with lib.maintainers; [ guibert ];
    platforms = lib.platforms.linux;
  };
}
