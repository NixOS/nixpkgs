
{ stdenv, fetchgit, fetchurl, unzip }:

stdenv.mkDerivation {
  name = "argu-1.1.2";

  src = fetchurl {
    url    = "https://api.nuget.org/packages/argu.1.1.2.nupkg";
    sha256 = "97688111dc7aa95e63f40b79e033bd12f4c1987eaf3455ec6395c1e62de8fd7e";
  };

  phases = [ "unpackPhase" ];

  buildInputs = [ unzip ];

  unpackPhase = ''
    mkdir -p "$out/lib/mono/packages/argu-1.1.2/Argu";
    unzip -x "$src" -d "$out/lib/mono/packages/argu-1.1.2/Argu";
  '';
}
