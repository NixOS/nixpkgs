{ stdenv, callPackage, lib, sasl, boost, Security, CoreFoundation, cctools }:

let
  buildMongoDB = callPackage ./mongodb.nix {
    inherit sasl boost Security CoreFoundation cctools;
  };
  variants = if stdenv.isLinux then
    {
      version = "5.0.22";
      sha256 = "sha256-NIsx6nwXGsuk+ff+LOCwOMpT/HAaNn89t4jtJvKprIA=";
      patches = [ ./fix-build-with-boost-1.79-5_0-linux.patch ];
    }
  else lib.optionalAttrs stdenv.isDarwin
    {
      version = "5.0.3"; # at least darwin has to stay on 5.0.3 until the SDK used by nixpkgs is bumped to 10.13
      sha256 = "1p9pq0dfd6lynvnz5p1c8dqp4filzrz86j840xwxwx82dm1zl6p0";
      patches = [ ./fix-build-with-boost-1.79-5_0.patch ]; # no darwin in name to prevent unnecessary rebuild
    };
in
buildMongoDB {
  version = variants.version;
  sha256 = variants.sha256;
  patches = [
    ./forget-build-dependencies-4-4.patch
    ./asio-no-experimental-string-view-4-4.patch
    ./fix-gcc-Wno-exceptions-5.0.patch
  ] ++ variants.patches;
}
