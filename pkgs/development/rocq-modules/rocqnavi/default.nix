{
  lib,
  mkRocqDerivation,
  rocq-core,
  version ? null,
}:

with lib;
let
  minVersion = "0.6.0";
  isNumericVersion = v: v != null && (builtins.match "[0-9]+\\.[0-9]+(\\.[0-9]+)?" v) != null;
  isUnsupportedOldVersion = isNumericVersion version && versions.isLt minVersion version;
in
if isUnsupportedOldVersion then
  throw ''
    rocqnavi: version "${version}" is not supported by this Nix package.
    rocqnavi < ${minVersion} used a Makefile-only layout that is no longer built here.
    Use version >= ${minVersion}, or "master".
  ''
else
  mkRocqDerivation {
    pname = "rocqnavi";
    owner = "affeldt-aist";
    opam-name = "rocq-navi";

    inherit version;
    defaultVersion =
      let
        case = case: out: { inherit case out; };
      in
      with versions;
      switch rocq-core.rocq-version [
        (case (range "9.0" "9.3") "0.6.0")
      ] null;
    release = {
      "0.6.0".hash = "sha256-Ahu54GDrY9NclLCv667S+fNC9xD0ZiZF0CmKgg7kziM=";
    };
    releaseRev = v: "rocqnavi." + v;

    nativeBuildInputs =
      let
        ocamlpkgs = rocq-core.ocamlPackages;
      in
      [
        ocamlpkgs.yojson
        ocamlpkgs.dune-glob
      ];

    ## Does the package contain OCaml code?
    mlPlugin = true;
    useDune = true;
    installPhase = ''
      runHook preInstall
      dune install --prefix=$out --libdir $OCAMLFIND_DESTDIR rocq-navi
      runHook postInstall
    '';

    meta = {
      description = "Rocqnavi: an HTML documentation generator for Rocq prover";
      maintainers = with maintainers; [ cohencyril ];
      license = licenses.gpl2;
    };
  }
