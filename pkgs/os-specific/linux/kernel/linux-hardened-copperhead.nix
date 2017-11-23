{ stdenv, hostPlatform, fetchFromGitHub, perl, buildLinux, ... } @ args:

with stdenv.lib;

let
  version = "4.14.1";
  revision = "a";
  sha256 = "0yp05xyz2ygxkhd17s85cqnvi93a49svgm0l1kbyb7y08mg5gp4j";

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
