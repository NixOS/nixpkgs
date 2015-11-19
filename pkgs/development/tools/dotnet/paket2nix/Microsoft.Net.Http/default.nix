
{ stdenv, fetchgit, fetchurl, unzip }:

stdenv.mkDerivation {
  name = "microsoft.net.http-2.2.29";

  src = fetchurl {
    url    = "https://api.nuget.org/packages/microsoft.net.http.2.2.29.nupkg";
    sha256 = "300545178dde5bc98acbb0c432254155ede1af4a3d3921fd3bed57acf981381d";
  };

  phases = [ "unpackPhase" ];

  buildInputs = [ unzip ];

  unpackPhase = ''
    mkdir -p "$out/lib/mono/packages/microsoft.net.http-2.2.29/Microsoft.Net.Http";
    unzip -x "$src" -d "$out/lib/mono/packages/microsoft.net.http-2.2.29/Microsoft.Net.Http";
  '';
}
