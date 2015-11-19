
{ stdenv, fetchgit, fetchurl, unzip }:

stdenv.mkDerivation {
  name = "fsharp.core-4.0.0.1";

  src = fetchurl {
    url    = "https://api.nuget.org/packages/fsharp.core.4.0.0.1.nupkg";
    sha256 = "f67929917b5d91f03019718ea5eec5aefcd38b7f15feb677c981a2df3a93d006";
  };

  phases = [ "unpackPhase" ];

  buildInputs = [ unzip ];

  unpackPhase = ''
    mkdir -p "$out/lib/mono/packages/fsharp.core-4.0.0.1/FSharp.Core";
    unzip -x "$src" -d "$out/lib/mono/packages/fsharp.core-4.0.0.1/FSharp.Core";
  '';
}
