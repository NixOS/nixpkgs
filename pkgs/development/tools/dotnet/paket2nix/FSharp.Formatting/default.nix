
{ stdenv, fetchgit, fetchurl, unzip }:

stdenv.mkDerivation {
  name = "fsharp.formatting-2.12.0";

  src = fetchurl {
    url    = "https://api.nuget.org/packages/fsharp.formatting.2.12.0.nupkg";
    sha256 = "0aef25d948870a429dcdda64c520b4dc20820cb0ac415e0a77af9698ae420b67";
  };

  phases = [ "unpackPhase" ];

  buildInputs = [ unzip ];

  unpackPhase = ''
    mkdir -p "$out/lib/mono/packages/fsharp.formatting-2.12.0/FSharp.Formatting";
    unzip -x "$src" -d "$out/lib/mono/packages/fsharp.formatting-2.12.0/FSharp.Formatting";
  '';
}
