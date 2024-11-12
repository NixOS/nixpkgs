{ callPackage, ... }@args:

callPackage ./generic.nix (
  args
  // {
    version = "8.0.35-31";
    hash = "sha256-KHfgSi9bQlqsi5aDRBlSpdZgMfOrAwHK51k8KhQ9Udg=";

    # includes https://github.com/Percona-Lab/libkmip.git
    fetchSubmodules = true;

    extraPatches = [
      ./abi-check.patch
    ];

    extraPostInstall = ''
      rm -r "$out"/docs
    '';
  }
)
