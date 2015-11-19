
{ stdenv, fetchgit, fetchurl, unzip }:

stdenv.mkDerivation {
  name = "sourcelink.fake-1.1.0";

  src = fetchurl {
    url    = "https://api.nuget.org/packages/sourcelink.fake.1.1.0.nupkg";
    sha256 = "b7f098b574c1cfc62a64a46efc0449f9cef467d233c9d1a3d78a43bd52e31fa5";
  };

  phases = [ "unpackPhase" ];

  buildInputs = [ unzip ];

  unpackPhase = ''
    mkdir -p "$out/lib/mono/packages/sourcelink.fake-1.1.0/SourceLink.Fake";
    unzip -x "$src" -d "$out/lib/mono/packages/sourcelink.fake-1.1.0/SourceLink.Fake";
  '';
}
