{ stdenv, unzip }:
{ name, version, src, ... } @ args:

stdenv.mkDerivation ({
  inherit name version src;

  buildInputs = [ unzip ];
  dontBuild = true;
  unpackPhase = ''
    runHook preUnpack
    unzip $src
    runHook postUnpack
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p "$out"
    chmod -R +w .
    find . -mindepth 1 -maxdepth 1 | xargs cp -a -t "$out"
    runHook postInstall
  '';
} // args)
