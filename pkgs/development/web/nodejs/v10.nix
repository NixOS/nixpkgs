{ stdenv, callPackage, lib, openssl, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl; };
in
  buildNodejs {
    inherit enableNpm;
    version = "10.4.1";
    sha256 = "0i40mn8g71z7wildhnjp64j7fnlld32dibyq677bd4pra95migx5";
    patches = lib.optionals stdenv.isDarwin [ ./no-xcode-v7.patch ./no-xcodebuild.patch ];
  }
