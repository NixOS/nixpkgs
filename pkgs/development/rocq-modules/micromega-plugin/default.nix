{
  lib,
  mkRocqDerivation,
  rocq-core,
  version ? null,
}:

mkRocqDerivation {
  pname = "micromega-plugin";
  owner = "rocq-community";
  inherit version;
  defaultVersion =
    let
      case = case: out: { inherit case out; };
    in
    with lib.versions;
    lib.switch rocq-core.rocq-version [
      (case (range "9.0" "9.2") "1.1.0")
    ] null;

  release = {
    "1.1.0".hash = "sha256-CWMbGErC5bu20Yu9eskgslLkzmSof6klNlOYEkQjUjc=";
  };
  releaseRev = v: "v${v}";

  mlPlugin = true;
  useDune = true;

  nativeBuildInputs = [
    rocq-core.ocamlPackages.ppx_optcomp
  ];

  propagatedBuildInputs = [
    rocq-core.ocamlPackages.findlib
  ];

  configurePhase = ''
    patchShebangs etc/with-rocq-wrap.sh
  '';

  buildPhase = ''
    etc/with-rocq-wrap.sh dune build -p rocq-micromega-plugin @install ''${enableParallelBuilding:+-j $NIX_BUILD_CORES}
  '';

  installPhase = ''
    etc/with-rocq-wrap.sh dune install --root . rocq-micromega-plugin --prefix=$out --libdir $OCAMLFIND_DESTDIR
    mkdir $out/lib/coq/
    mv $OCAMLFIND_DESTDIR/coq $out/lib/coq/${rocq-core.rocq-version}
  '';

  meta = {
    description = "Plugin for (semi)decision procedures for arithmetic.";
    license = lib.licenses.lgpl21;
  };
}
