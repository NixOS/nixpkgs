{ stdenvNoCC }:

version: pname:
stdenvNoCC.mkDerivation {
  inherit pname version;

  buildCommand = ''
    mkdir -p "$out"
    echo "Individual frameworks have been deprecated. See the stdenv documentation for how to use `apple-sdk`" \
        > "$out/README"
  '';

  passthru.isDarwinCompatStub = true;
}
