{ callPackage, darwin }:

rec {
  corefoundation = callPackage ./corefoundation.nix { inherit (darwin) objc4 ICU; };
  libdispatch = callPackage ./libdispatch.nix {
   inherit (darwin) apple_sdk_sierra xnu;
  };
}
