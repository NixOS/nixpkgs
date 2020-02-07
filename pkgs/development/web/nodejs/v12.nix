{ stdenv, callPackage, openssl, icu, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl icu; };
in
  buildNodejs {
    inherit enableNpm;
    version = "12.15.0";
    sha256 = "06x8sma4rxbw0mxj0l4438lfpv9abxmnw2ibamq1acng1jl4zyyj";

    patches = stdenv.lib.optionals stdenv.isDarwin [ ./disable-libatomic-darwin.patch ];
  }
