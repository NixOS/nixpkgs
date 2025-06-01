{
  lib,
  mkRocqDerivation,
  which,
  rocq-core,
  version ? null,
  elpi-version ? null,
}:

let
  default-elpi-version =
    if elpi-version != null then
      elpi-version
    else
      (lib.switch rocq-core.rocq-version [
        {
          case = "9.0";
          out = "2.0.7";
        }
      ] { });
  elpi = rocq-core.ocamlPackages.elpi.override { version = default-elpi-version; };
  propagatedBuildInputs_wo_elpi = [
    rocq-core.ocamlPackages.findlib
    rocq-core.ocamlPackages.ppx_optcomp
  ];
  derivation = mkRocqDerivation {
    pname = "elpi";
    repo = "coq-elpi";
    owner = "LPCIC";
    inherit version;
    defaultVersion = lib.switch rocq-core.rocq-version [
      {
        case = "9.0";
        out = "2.5.2";
      }
    ] null;
    release."2.5.2".sha256 = "sha256-lLzjPrbVB3rrqox528YiheUb0u89R84Xmrgkn0oplOs=";
    releaseRev = v: "v${v}";

    mlPlugin = true;
    useDune = true;

    propagatedBuildInputs = propagatedBuildInputs_wo_elpi ++ [ elpi ];

    configurePhase = ''
      patchShebangs etc/with-rocq-wrap.sh
      make dune-files || true
    '';

    buildPhase = ''
      etc/with-rocq-wrap.sh dune build -p rocq-elpi @install ''${enableParallelBuilding:+-j $NIX_BUILD_CORES}
    '';

    installPhase = ''
      etc/with-rocq-wrap.sh dune install --root . rocq-elpi --prefix=$out --libdir $OCAMLFIND_DESTDIR
      mkdir $out/lib/coq/
      mv $OCAMLFIND_DESTDIR/coq $out/lib/coq/${rocq-core.rocq-version}
    '';

    meta = {
      description = "Rocq plugin embedding ELPI";
      maintainers = [ lib.maintainers.cohencyril ];
      license = lib.licenses.lgpl21Plus;
    };
  };
  patched-derivation1 = derivation.overrideAttrs (
    o:
    lib.optionalAttrs (o ? elpi-version) {
      propagatedBuildInputs = propagatedBuildInputs_wo_elpi ++ [
        (rocq-core.ocamlPackages.elpi.override { version = o.elpi-version; })
      ];
    }
  );
in
patched-derivation1
