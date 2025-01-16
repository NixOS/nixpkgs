{ pkgs ? import <nixpkgs> {} }:

let
  lib = pkgs.lib;
  rustPlatform = pkgs.rustPlatform;
  fetchFromGitHub = pkgs.fetchFromGitHub;
in

rustPlatform.buildRustPackage rec {
  pname = "statcat";
  version = "3.1.0.beta";

  src = fetchFromGitHub {
    owner = "FluffoCJ";
    repo = "StatCat";
    rev = "main";
    hash = "sha256-HbFvBg91ymG7shzNMnT1HrZ4oj+x3LJsP7IM6yHXEb4=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  meta = {
    description = "Configurable Linux System Fetch Written In Rust";
    homepage = "https://github.com/FluffoCJ/StatCat";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ FluffoCJ ];
    mainProgram = "statcat";
  };
}

