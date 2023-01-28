{ stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation {
  pname = "darwin-stubs";
  version = "10.12";

  src = ~/src/darwin-stubs/stubs-10.12.tar.gz;

  dontBuild = true;

  installPhase = ''
    mkdir $out
    mv * $out
  '';
}
