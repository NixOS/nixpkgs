<<<<<<< HEAD
{ lib, buildGoModule, fetchFromGitHub, buildNpmPackage
, nixosTests, debianutils, mkdocs, python3, python3Packages
}:


buildGoModule rec {
  pname = "ntfy-sh";
  version = "2.7.0";
=======
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
  version = "2.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "binwiederhier";
    repo = "ntfy";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-cL/vvwwFH3ztQUVqjZmO2nPmqCyuFMPCtMcRwNvEfNc=";
  };

  vendorHash = "sha256-nCzBWANnNAwUw17EPs0G9ezpKJG+Ix1E7IhdvxFe3Xc=";

  ui = buildNpmPackage {
    inherit src version;
    pname = "ntfy-sh-ui";
    npmDepsHash = "sha256-qDpCI65r3S9WMEmYQeyY2KRpLnP6oxEL6rrhj0MGeWk=";

    prePatch = ''
      cd web/
    '';

    installPhase = ''
      mv build/index.html build/app.html
      rm build/config.js
      mkdir -p $out
      mv build/ $out/site
    '';
  };
=======
    sha256 = "sha256-bwYiIeDpZZpfv/HNtB/3acL0dJfegF/4OqWcEV8YGfY=";
  };

  vendorSha256 = "sha256-HHuj3PcIu1wsdcfd04PofoZHjRSgTfWfJcomqH3KXa8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  nativeBuildInputs = [
    debianutils
    mkdocs
<<<<<<< HEAD
=======
    nodejs
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    python3
    python3Packages.mkdocs-material
    python3Packages.mkdocs-minify
    python3Packages.mkdocs-simple-hooks
  ];

  postPatch = ''
    sed -i 's# /bin/echo# echo#' Makefile
  '';

  preBuild = ''
<<<<<<< HEAD
    cp -r ${ui}/site/ server/
    make docs-build
=======
    ln -s ${nodeDependencies}/lib/node_modules web/node_modules
    DISABLE_ESLINT_PLUGIN=true npm_config_offline=true make web-build docs-build
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
