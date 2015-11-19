
{ stdenv, fetchgit, fetchurl, unzip }:

stdenv.mkDerivation {
  name = "microsoft.bcl.build-1.0.21";

  src = fetchurl {
    url    = "https://api.nuget.org/packages/microsoft.bcl.build.1.0.21.nupkg";
    sha256 = "c1f43aeb79b44680a8bf06d28c4d7dd2f89542ed22fd89c41f7bfc832e6a0870";
  };

  phases = [ "unpackPhase" ];

  buildInputs = [ unzip ];

  unpackPhase = ''
    mkdir -p "$out/lib/mono/packages/microsoft.bcl.build-1.0.21/Microsoft.Bcl.Build";
    unzip -x "$src" -d "$out/lib/mono/packages/microsoft.bcl.build-1.0.21/Microsoft.Bcl.Build";
  '';
}
