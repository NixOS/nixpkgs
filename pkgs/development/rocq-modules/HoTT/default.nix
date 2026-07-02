{
  lib,
  mkRocqDerivation,
  rocq-core,
  version ? null,
}:

mkRocqDerivation {
  pname = "HoTT";
  repo = "Coq-HoTT";
  owner = "HoTT";
  inherit version;
  defaultVersion =
    with lib.versions;
    lib.switch rocq-core.rocq-version [
      {
        case = range "9.0" "9.1";
        out = rocq-core.rocq-version;
      }
    ] null;
  releaseRev = v: "V${v}";
  release."9.0".sha256 = "sha256-etdLH1qDyDc+ZM7K/65iib0MRlLhsnVmzWBCULUDD50=";
  release."9.1".sha256 = "sha256-JntL5kQh3UZTbC/Crk+Fu3GBGkfrGx3cr9b7EBmCTts=";

  opam-name = "coq-hott";
  useDune = true;

  patchPhase = ''
    patchShebangs etc
  '';

  meta = {
    homepage = "https://homotopytypetheory.org/";
    description = "Homotopy Type Theory library";
    longDescription = ''
      Homotopy Type Theory is an interpretation of Martin-Löf’s intensional
      type theory into abstract homotopy theory. Propositional equality is
      interpreted as homotopy and type isomorphism as homotopy equivalence.
      Logical constructions in type theory then correspond to
      homotopy-invariant constructions on spaces, while theorems and even
      proofs in the logical system inherit a homotopical meaning. As the
      natural logic of homotopy, type theory is also related to higher
      category theory as it is used e.g. in the notion of a higher topos.

      The HoTT library is a development of homotopy-theoretic ideas in the Coq
      proof assistant. It draws many ideas from Vladimir Voevodsky's
      Foundations library (which has since been incorporated into the Unimath
      library) and also cross-pollinates with the HoTT-Agda library.
    '';
    maintainers = with lib.maintainers; [
      alizter
      siddharthist
    ];
  };
}
