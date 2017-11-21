{ stdenv, hostPlatform, fetchFromGitHub, perl, buildLinux, ... } @ args:

with stdenv.lib;

let
  version = "4.13.14";
  revision = "a";
  sha256 = "16bb1jvip50v62slp6cy96zncjhjzp3hvh29jc8ilcpxgyipmhlc";

  modVersion = "${version}-hardened";
in
import ./generic.nix (args // {
  inherit modVersion;

  version = "${version}-${revision}";

  src = fetchFromGitHub {
    inherit sha256;
    owner = "copperhead";
    repo = "linux-hardened";
    rev = "${version}.${revision}";
  };
} // (args.argsOverride or {}))
