{ stdenv, akku, makeWrapper }:
{ name, version, src, buildInputs ? [ ], ... }:
stdenv.mkDerivation {
  inherit name version src;
  propagatedBuildInputs = buildInputs;
  buildInputs = [ ];
  nativeBuildInputs = [ makeWrapper akku ];
  installPhase = ''
    runHook preInstall

    # tests aren't exported modules
    rm -rf tests

    # should only install the project
    rm -f Akku.lock Akku.manifest

    akku install

    mkdir $out
    cp -rL .akku/lib $out/lib
    rm -f .akku/bin/activate*
    cp -rL .akku/bin $out/bin

    for f in $out/bin/*
    do
    wrapProgram $f \
      --prefix CHEZSCHEMELIBDIRS : $CHEZSCHEMELIBDIRS
    done

    runHook postInstall
  '';
  setupHook = ./setup-hook.sh;
}
