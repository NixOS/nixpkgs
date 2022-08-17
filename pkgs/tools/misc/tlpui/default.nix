{
  lib,
  pkgs,
  wrapGAppsHook,
  fetchFromGitHub,
  buildPythonPackage,
}:
with lib;
  buildPythonPackage rec {
    pname = "tlpui";
    version = "1.5.0-5";

    # src = fetchFromGitHub {
    #   owner = "d4nj1";
    #   repo = "TLPUI";
    #   rev = "tlpui-${version}";
    #   sha256 = "sha256-Xzp+UrgPQ6OHEgnQ1aRvaZ+NWCSjeLdXG88zlgsaTw0=";
    # };

    src = fetchFromGitHub {
      owner = "GeorgesAlkhouri";
      repo = "TLPUI";
      rev = "4c8b381f74cc7a21c0c16f86fc0626a17f984eea";
      sha256 = "sha256-URdYZJh9dcWhdtTQee7KUUaQngTNHppL/rb2NSPrSSE=";
    };

    doCheck = false;
    # TODO enable tests
    # checkInputs = with pkgs.python3Packages; [tox pycodestyle];
    # checkPhase = "tox";
    nativeBuildInputs = [wrapGAppsHook];

    buildInputs = with pkgs; [
      gtk3
      cairo
      gobject-introspection
    ];
    # sandbox = true;
    propagatedBuildInputs = with pkgs; with pkgs.python3Packages; [pycairo pygobject3 tlp pciutils usbutils];

    meta = {
      homepage = "https://github.com/d4nj1/TLPUI";
      description = "A GTK user interface for TLP written in Python";
      longDescription = ''
        The Python scripts in this project generate a GTK-UI to change TLP configuration files easily.
        It has the aim to protect users from setting bad configuration and to deliver a basic overview of all the valid configuration values.
      '';
      license = licenses.gpl2Only;
      platforms = platforms.linux;
      maintainers = with maintainers; [];
    };
  }
# nix-build -E '((import <nixpkgs> {}).pkgs.python3Packages.callPackage (import ./default.nix) { })'
# nix-build -E '((import ../../../../default.nix {}).pkgs.python3Packages.callPackage (import ./default.nix) { })'

