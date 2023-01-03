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
  version = "1.29.1";

  src = fetchFromGitHub {
    owner = "binwiederhier";
    repo = "ntfy";
    rev = "v${version}";
    sha256 = "sha256-ikXhST+fvXu7FBeoYMzPq2LhpAw3gfaES1WlhnRO8BY=";
  };

  vendorSha256 = "sha256-VVqaQFluqV77/+Asu9xSBpCvoYr276UE3Yg+iNkxP0o=";

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
