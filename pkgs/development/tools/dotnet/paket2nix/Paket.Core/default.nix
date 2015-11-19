
{ stdenv, fetchgit, fetchurl, unzip }:

stdenv.mkDerivation {
  name = "paket.core-2.25.1";

  src = fetchurl {
    url    = "https://api.nuget.org/packages/paket.core.2.25.1.nupkg";
    sha256 = "429c1578d99d87b0d8458df47afa2ab1ee2bc72763372cdd98ed67c653d61a73";
  };

  phases = [ "unpackPhase" ];

  buildInputs = [ unzip ];

  unpackPhase = ''
    mkdir -p "$out/lib/mono/packages/paket.core-2.25.1/Paket.Core";
    unzip -x "$src" -d "$out/lib/mono/packages/paket.core-2.25.1/Paket.Core";
  '';
}
