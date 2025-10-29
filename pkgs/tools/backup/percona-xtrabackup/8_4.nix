{ callPackage, ... }@args:

callPackage ./generic.nix (
  args
  // {
    version = "8.4.0-4";
    hash = "sha256-ws+si8bpalL8y7l9W+R4B02GnnGOou50txtS6ktntP4=";

    # includes https://github.com/Percona-Lab/libkmip.git
    fetchSubmodules = true;

    extraPatches = [
    ];

    extraPostInstall = '''';
  }
)
