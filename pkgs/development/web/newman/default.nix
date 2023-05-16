<<<<<<< HEAD
{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "newman";
  version = "5.3.2";

  src = fetchFromGitHub {
    owner = "postmanlabs";
    repo = "newman";
    rev = "refs/tags/v${version}";
    hash = "sha256-j5YS9Zbk9b3K4+0sGzqtCgEsR+S5nGPf/rebeGzsscA=";
  };

  npmDepsHash = "sha256-FwVmesHtzTZKsTCIfZiRPb1zf7q5LqABAZOh8gXB9qw=";

  dontNpmBuild = true;

  meta = with lib; {
    homepage = "https://www.getpostman.com";
    description = "A command-line collection runner for Postman";
    changelog = "https://github.com/postmanlabs/newman/releases/tag/v${version}";
=======
{ pkgs, nodejs, stdenv, lib, ... }:

let

  packageName = with lib; concatStrings (map (entry: (concatStrings (mapAttrsToList (key: value: "${key}-${value}") entry))) (importJSON ./package.json));

  nodePackages = import ./node-composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };
in
nodePackages.newman.override {
  meta = with lib; {
    homepage = "https://www.getpostman.com";
    description = "A command-line collection runner for Postman";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.asl20;
  };
}
