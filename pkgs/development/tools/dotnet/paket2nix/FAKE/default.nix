
{ stdenv, fetchgit, fetchurl, unzip }:

stdenv.mkDerivation {
  name = "fake-4.9.1";

  src = fetchurl {
    url    = "https://api.nuget.org/packages/fake.4.9.1.nupkg";
    sha256 = "1b616c4dd98a9adad02ba72aa1c45358e84eda844eb7b759d60cc78555d8b9cc";
  };

  phases = [ "unpackPhase" ];

  buildInputs = [ unzip ];

  unpackPhase = ''
    mkdir -p "$out/lib/mono/packages/fake-4.9.1/FAKE";
    unzip -x "$src" -d "$out/lib/mono/packages/fake-4.9.1/FAKE";
  '';
}
