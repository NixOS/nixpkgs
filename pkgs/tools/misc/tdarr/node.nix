{ callPackage, ccextractor }:

callPackage ./common.nix { } {
  pname = "tdarr-node";
  component = "node";

  hashes = {
    linux_x64 = "sha256-ITL0Hwvg2+AqWA9tup0vPU6/2hMNFdLaWKKBfWPyWuU=";
    linux_arm64 = "sha256-sIayVxJhod4AGaSEXjGLNGc7d0953X1NHXZ7zHDYSTU=";
    darwin_x64 = "sha256-s3CJ9he2WvtA0rLAyrshUKHYa2W0H46L9XWd0t2x6ek=";
    darwin_arm64 = "sha256-Jkhxir8Vdgo8mN1WWCLCRvKFgPEkToUzDNbnHbraz3c=";
  };

  includeInPath = [ ccextractor ];
}
