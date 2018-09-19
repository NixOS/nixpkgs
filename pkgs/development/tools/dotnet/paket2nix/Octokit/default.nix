
{ stdenv, fetchgit, fetchurl, unzip }:

stdenv.mkDerivation {
  name = "octokit-0.16.0";

  src = fetchurl {
    url    = "https://api.nuget.org/packages/octokit.0.16.0.nupkg";
    sha256 = "146cfdb851b9a9fd62e1b1718e45b206d01a60e9b0772c5a6bc8372461843cc8";
  };

  phases = [ "unpackPhase" ];

  buildInputs = [ unzip ];

  unpackPhase = ''
    mkdir -p "$out/lib/mono/packages/octokit-0.16.0/Octokit";
    unzip -x "$src" -d "$out/lib/mono/packages/octokit-0.16.0/Octokit";
  '';
}
