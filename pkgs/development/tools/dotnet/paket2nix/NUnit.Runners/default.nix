
{ stdenv, fetchgit, fetchurl, unzip }:

stdenv.mkDerivation {
  name = "nunit.runners-2.6.4";

  src = fetchurl {
    url    = "https://api.nuget.org/packages/nunit.runners.2.6.4.nupkg";
    sha256 = "44877aeb399ffb14b30ecca1c073813aab71dcf9a92986d16f31d919f789d586";
  };

  phases = [ "unpackPhase" ];

  buildInputs = [ unzip ];

  unpackPhase = ''
    mkdir -p "$out/lib/mono/packages/nunit.runners-2.6.4/NUnit.Runners";
    unzip -x "$src" -d "$out/lib/mono/packages/nunit.runners-2.6.4/NUnit.Runners";
  '';
}
