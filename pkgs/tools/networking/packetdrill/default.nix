{ stdenv, fetchFromGitHub, bison, flex }:
stdenv.mkDerivation {
  version = "1.0";
  pname = "packetdrill";
  src = fetchFromGitHub {
    owner = "google";
    repo = "packetdrill";
    rev = "58a7865c47e3a71e92ca0e4cc478c320e1c35f82";
    sha256 = "09sqiakmn63idfjhy2ddf1456sfhi8yhsbp8lxvc1yfjikjxwwbc";
  };
  setSourceRoot = ''
    export sourceRoot=$(realpath */gtests/net/packetdrill)
  '';
  NIX_CFLAGS_COMPILE = [
    "-Wno-error=unused-result"
    "-Wno-error=stringop-truncation"
    "-Wno-error=address-of-packed-member"
  ];
  nativeBuildInputs = [ bison flex ];
  patches = [ ./nix.patch ];
  enableParallelBuilding = true;
  meta = {
    description = "Quick, precise tests for entire TCP/UDP/IPv4/IPv6 network stacks";
    homepage = https://github.com/google/packetdrill;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ dmjio cleverca22 ];
  };
}
