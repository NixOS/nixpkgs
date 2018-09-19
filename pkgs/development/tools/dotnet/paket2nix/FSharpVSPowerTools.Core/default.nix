
{ stdenv, fetchgit, fetchurl, unzip }:

stdenv.mkDerivation {
  name = "fsharpvspowertools.core-2.1.0";

  src = fetchurl {
    url    = "https://api.nuget.org/packages/fsharpvspowertools.core.2.1.0.nupkg";
    sha256 = "2645fd6f2c67a2203b138c320278a1f88e829b279ea115170e49c70ee4ad5f3d";
  };

  phases = [ "unpackPhase" ];

  buildInputs = [ unzip ];

  unpackPhase = ''
    mkdir -p "$out/lib/mono/packages/fsharpvspowertools.core-2.1.0/FSharpVSPowerTools.Core";
    unzip -x "$src" -d "$out/lib/mono/packages/fsharpvspowertools.core-2.1.0/FSharpVSPowerTools.Core";
  '';
}
