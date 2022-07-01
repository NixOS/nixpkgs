{ stdenv, callPackage, lib, sasl, boost, Security, CoreFoundation, cctools }:

let
  buildMongoDB = callPackage ./mongodb.nix {
    inherit sasl boost Security CoreFoundation cctools;
  };
  variants = if stdenv.isLinux then
    {
      version = "5.0.7";
      sha256 = "sha256-1PeDBZJNqJXHH/cSh2e+WR0PfS/b7XuJEzkkbrRT/gc=";
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
