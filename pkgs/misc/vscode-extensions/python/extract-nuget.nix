{ stdenv, unzip }:
{ name, version, src, ... }:

stdenv.mkDerivation {
  inherit name version src;

  nativeBuildInputs = [ unzip ];
  dontBuild = true;
  unpackPhase = "unzip $src";
  installPhase = ''
    mkdir -p "$out"
    chmod -R +w .
    find . -mindepth 1 -maxdepth 1 | xargs cp -a -t "$out"
  '';
}
