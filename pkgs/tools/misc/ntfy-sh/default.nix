{ lib, pkgs, stdenv, buildGoModule, fetchFromGitHub, nixosTests
, nodejs, debianutils, mkdocs, python3, python3Packages }:


let
  nodeDependencies = (import ./node-composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  }).nodeDependencies;
in
buildGoModule rec {
  pname = "ntfy-sh";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "binwiederhier";
    repo = "ntfy";
    rev = "v${version}";
    sha256 = "sha256-pBwlFkkXDgPhGfn2bhwuJTGQz+O0ADhPUU2Fogl98zA=";
  };

  vendorSha256 = "sha256-XePJaXD83731r5CJG1PHnpU6s+443yq8mrqx7ZPU8Gs=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  nativeBuildInputs = [
    debianutils
    mkdocs
    nodejs
    python3
    python3Packages.mkdocs-material
    python3Packages.mkdocs-minify
  ];

  postPatch = ''
    sed -i 's# /bin/echo# echo#' Makefile
  '';

  preBuild = ''
    ln -s ${nodeDependencies}/lib/node_modules web/node_modules
    DISABLE_ESLINT_PLUGIN=true npm_config_offline=true make web-build docs-build
  '';

  passthru = {
    updateScript = ./update.sh;
    tests.ntfy-sh = nixosTests.ntfy-sh;
  };

  meta = with lib; {
    description = "Send push notifications to your phone or desktop via PUT/POST";
    homepage = "https://ntfy.sh";
    license = licenses.asl20;
    maintainers = with maintainers; [ arjan-s fpletz ];
  };
}
