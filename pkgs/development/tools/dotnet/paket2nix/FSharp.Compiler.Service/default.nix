
{ stdenv, fetchgit, fetchurl, unzip }:

stdenv.mkDerivation {
  name = "fsharp.compiler.service-1.4.0.6";

  src = fetchurl {
    url    = "https://api.nuget.org/packages/fsharp.compiler.service.1.4.0.6.nupkg";
    sha256 = "83dc0f5c56f65f2a9501e4ba011b9c46c5952fde90785ca4b5a0e7aceb7cd0ab";
  };

  phases = [ "unpackPhase" ];

  buildInputs = [ unzip ];

  unpackPhase = ''
    mkdir -p "$out/lib/mono/packages/fsharp.compiler.service-1.4.0.6/FSharp.Compiler.Service";
    unzip -x "$src" -d "$out/lib/mono/packages/fsharp.compiler.service-1.4.0.6/FSharp.Compiler.Service";
  '';
}
