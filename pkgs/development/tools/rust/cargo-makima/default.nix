{ lib, rustPlatform, fetchCrate }:

 rustPlatform.buildRustPackage rec {
   pname = "cargo-makima";
   version = "0.1.1";

   src = fetchCrate {
     inherit pname version;
     sha256 = "sha256-hqt2c3vHmjl1m98EGzwwCbM+9SZuJ5v6IlNLk0GgEEA";
   };

   cargoSha256 = "sha256-+mYz0S1TMolXf0u6Q69SHG+ZPe/wR6I+ugMoOhzSwNg=";
 }
