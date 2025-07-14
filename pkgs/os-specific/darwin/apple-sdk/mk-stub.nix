{ lib, stdenvNoCC }:

prefix: version: pname:
lib.warnOnInstantiate
  "${prefix}.${pname}: these stubs do nothing and will be removed in Nixpkgs 25.11; see <https://nixos.org/manual/nixpkgs/stable/#sec-darwin> for documentation and migration instructions."
  (
    stdenvNoCC.mkDerivation {
      inherit pname version;

      buildCommand = ''
        mkdir -p "$out"
        echo "Individual frameworks have been deprecated. See the stdenv documentation for how to use `apple-sdk`" \
            > "$out/README"
      '';

      passthru.isDarwinCompatStub = true;
    }
  )
