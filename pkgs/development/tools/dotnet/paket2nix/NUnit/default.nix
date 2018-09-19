
{ stdenv, fetchgit, fetchurl, unzip }:

stdenv.mkDerivation {
  name = "nunit-2.6.4";

  src = fetchurl {
    url    = "https://api.nuget.org/packages/nunit.2.6.4.nupkg";
    sha256 = "be8cde6e9754474d5d4f553addb6331cf442c2182a0eb4dc87618d744fd59ca9";
  };

  phases = [ "unpackPhase" ];

  buildInputs = [ unzip ];

  unpackPhase = ''
    mkdir -p "$out/lib/mono/packages/nunit-2.6.4/NUnit";
    unzip -x "$src" -d "$out/lib/mono/packages/nunit-2.6.4/NUnit";
  '';
}
