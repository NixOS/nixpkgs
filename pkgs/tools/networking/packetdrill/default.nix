{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  version = "1.0";
  name = "packetdrill-${version}";
  src = pkgs.fetchFromGitHub {
    owner = "google";
    repo = "packetdrill";
    rev = "58a7865c47e3a71e92ca0e4cc478c320e1c35f82";
    sha256 = "09sqiakmn63idfjhy2ddf1456sfhi8yhsbp8lxvc1yfjikjxwwbc";
  };
  setSourceRoot = ''
    export sourceRoot=$(realpath */gtests/net/packetdrill)
  '';
  hardeningDisable = [ "all" ];
  buildInputs = with pkgs; [ bison flex ];
  patches = [ ./nix.patch ];
  enableParallelBuilding = true;

  meta = {
    description = "The packetdrill scripting tool enables quick, precise tests for entire TCP/UDP/IPv4/IPv6 network stacks, from the system call layer down to the NIC hardware";
    homepage = https://github.com/google/packetdrill;
    license = "GPLv2";
    platforms = stdenv.lib.platforms.gnu;
  };
}
