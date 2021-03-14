{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "15.11.0";
    sha256 = "1lfjm0jgzbr0a874c04pddbjnvjcdyx5vyaakdhp0fa222i92w0s";
  }
