{ stdenv, fetchFromGitHub, bison, flex }:
stdenv.mkDerivation rec {
  version = "1.0";
  name = "packetdrill-${version}";
  src = fetchFromGitHub {
    owner = "google";
    repo = "packetdrill";
    rev = "58a7865c47e3a71e92ca0e4cc478c320e1c35f82";
    sha256 = "09sqiakmn63idfjhy2ddf1456sfhi8yhsbp8lxvc1yfjikjxwwbc";
  };
  setSourceRoot = ''
    export sourceRoot=$(realpath */gtests/net/packetdrill)
  '';
  hardeningDisable = [ "all" ];
  buildInputs = [ bison flex ];
  patches = [ ./nix.patch ];
  enableParallelBuilding = true;
  meta = {
    description = "Quick, precise tests for entire TCP/UDP/IPv4/IPv6 network stacks";
    homepage = https://github.com/google/packetdrill;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ dmjio cleverca22 ];
  };
}
