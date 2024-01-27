import ./common.nix {
  version = "6.8";
  sha256 = "1i7yb7mrp3inz25zbzv2pllr4y7d58v818f1as7iz8mw53nm7dwf";
  patches = [
    # glibc 2.34 compat
    ./fix-glibc-2.34.patch
  ];
}
