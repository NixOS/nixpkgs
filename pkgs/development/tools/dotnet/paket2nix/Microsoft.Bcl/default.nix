
{ stdenv, fetchgit, fetchurl, unzip }:

stdenv.mkDerivation {
  name = "microsoft.bcl-1.1.10";

  src = fetchurl {
    url    = "https://api.nuget.org/packages/microsoft.bcl.1.1.10.nupkg";
    sha256 = "220680f4f1cc4e3db38ebf971ee8ad8bc5fe8ac213a3098443e38c6fcd8912a5";
  };

  phases = [ "unpackPhase" ];

  buildInputs = [ unzip ];

  unpackPhase = ''
    mkdir -p "$out/lib/mono/packages/microsoft.bcl-1.1.10/Microsoft.Bcl";
    unzip -x "$src" -d "$out/lib/mono/packages/microsoft.bcl-1.1.10/Microsoft.Bcl";
  '';
}
