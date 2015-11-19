
{ stdenv, fetchgit, fetchurl, unzip }:

stdenv.mkDerivation {
  name = "newtonsoft.json-7.0.1";

  src = fetchurl {
    url    = "https://api.nuget.org/packages/newtonsoft.json.7.0.1.nupkg";
    sha256 = "ff2a9942325b22cccfe3e505ac8abdf46b071bcc60ef44da464df929c60fc846";
  };

  phases = [ "unpackPhase" ];

  buildInputs = [ unzip ];

  unpackPhase = ''
    mkdir -p "$out/lib/mono/packages/newtonsoft.json-7.0.1/Newtonsoft.Json";
    unzip -x "$src" -d "$out/lib/mono/packages/newtonsoft.json-7.0.1/Newtonsoft.Json";
  '';
}
