{ stdenv, callPackage, lib, sasl, boost, Security, CoreFoundation, cctools }:

let
  buildMongoDB = callPackage ./mongodb.nix {
    inherit sasl boost Security CoreFoundation cctools;
  };
  variants = if stdenv.isLinux then
    {
      version = "5.0.5";
      sha256 = "1nny7a3w6pk8z9cwsz8kgk7gvf8lh5xb3r24drlr7wv970h90826";
    }
  else
    {
      version = "5.0.3"; # at least darwin has to stay on 5.0.3 until the SDK used by nixpkgs is bumped to 10.13
      sha256 = "1p9pq0dfd6lynvnz5p1c8dqp4filzrz86j840xwxwx82dm1zl6p0";
    };
in
buildMongoDB {
  version = variants.version;
  sha256 = variants.sha256;
  patches = [
    ./forget-build-dependencies-4-4.patch
    ./asio-no-experimental-string-view-4-4.patch
  ];
}
