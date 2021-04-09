{ lib, callPackage, newScope, recurseIntoAttrs, ocamlPackages_4_05, ocamlPackages_4_09
, ocamlPackages_4_10, compcert
}@args:
let lib = import ../build-support/coq/extra-lib.nix {inherit (args) lib;}; in
let
  mkCoqPackages' = self: coq:
    let callPackage = self.callPackage; in {
      inherit coq lib;
      coqPackages = self;

      mkCoqDerivation = callPackage ../build-support/coq {};

      contribs = recurseIntoAttrs
        (callPackage ../development/coq-modules/contribs {});

      autosubst = callPackage ../development/coq-modules/autosubst {};
      bignums = if lib.versionAtLeast coq.coq-version "8.6"
        then callPackage ../development/coq-modules/bignums {}
        else null;
      category-theory = callPackage ../development/coq-modules/category-theory { };
      Cheerios = callPackage ../development/coq-modules/Cheerios {};
      CoLoR = callPackage ../development/coq-modules/CoLoR {};
      coq-bits = callPackage ../development/coq-modules/coq-bits {};
      coq-elpi = callPackage ../development/coq-modules/coq-elpi {};
      coq-ext-lib = callPackage ../development/coq-modules/coq-ext-lib {};
      coq-haskell = callPackage ../development/coq-modules/coq-haskell { };
      coqeal = callPackage ../development/coq-modules/coqeal {};
      coqhammer = callPackage ../development/coq-modules/coqhammer {};
      coqprime = callPackage ../development/coq-modules/coqprime {};
      coqtail-math = callPackage ../development/coq-modules/coqtail-math {};
      coquelicot = callPackage ../development/coq-modules/coquelicot {};
      corn = callPackage ../development/coq-modules/corn {};
      dpdgraph = callPackage ../development/coq-modules/dpdgraph {};
      equations = callPackage ../development/coq-modules/equations { };
      fiat_HEAD = callPackage ../development/coq-modules/fiat/HEAD.nix {};
      flocq = callPackage ../development/coq-modules/flocq {};
      fourcolor = callPackage ../development/coq-modules/fourcolor {};
      gappalib = callPackage ../development/coq-modules/gappalib {};
      heq = callPackage ../development/coq-modules/heq {};
      hierarchy-builder = callPackage ../development/coq-modules/hierarchy-builder {};
      HoTT = callPackage ../development/coq-modules/HoTT {};
      interval = callPackage ../development/coq-modules/interval {};
      InfSeqExt = callPackage ../development/coq-modules/InfSeqExt {};
      iris = callPackage ../development/coq-modules/iris {};
      ltac2 = callPackage ../development/coq-modules/ltac2 {};
      math-classes = callPackage ../development/coq-modules/math-classes { };
      mathcomp = callPackage ../development/coq-modules/mathcomp {};
      ssreflect          = self.mathcomp.ssreflect;
      mathcomp-ssreflect = self.mathcomp.ssreflect;
      mathcomp-fingroup  = self.mathcomp.fingroup;
      mathcomp-algebra   = self.mathcomp.algebra;
      mathcomp-solvable  = self.mathcomp.solvable;
      mathcomp-field     = self.mathcomp.field;
      mathcomp-character = self.mathcomp.character;
      mathcomp-abel = callPackage ../development/coq-modules/mathcomp-abel {};
      mathcomp-analysis = callPackage ../development/coq-modules/mathcomp-analysis {};
      mathcomp-finmap = callPackage ../development/coq-modules/mathcomp-finmap {};
      mathcomp-bigenough = callPackage ../development/coq-modules/mathcomp-bigenough {};
      mathcomp-real-closed = callPackage ../development/coq-modules/mathcomp-real-closed {};
      metalib = callPackage ../development/coq-modules/metalib { };
      multinomials = callPackage ../development/coq-modules/multinomials {};
      odd-order = callPackage ../development/coq-modules/odd-order { };
      paco = callPackage ../development/coq-modules/paco {};
      paramcoq = callPackage ../development/coq-modules/paramcoq {};
      QuickChick = callPackage ../development/coq-modules/QuickChick {};
      simple-io = callPackage ../development/coq-modules/simple-io { };
      stdpp = callPackage ../development/coq-modules/stdpp { };
      StructTact = callPackage ../development/coq-modules/StructTact {};
      tlc = callPackage ../development/coq-modules/tlc {};
      Velisarios = callPackage ../development/coq-modules/Velisarios {};
      Verdi = callPackage ../development/coq-modules/Verdi {};
      VST = callPackage ../development/coq-modules/VST {
        compcert = compcert.override { version = "3.7"; };
      };
      filterPackages = doesFilter: if doesFilter then filterCoqPackages self else self;
    };

  filterCoqPackages = set:
    lib.listToAttrs (
      lib.concatMap (name: let v = set.${name} or null; in
          lib.optional (! v.meta.coqFilter or false)
            (lib.nameValuePair name (
              if lib.isAttrs v && v.recurseForDerivations or false
              then filterCoqPackages v
              else v))
      ) (lib.attrNames set)
    );
  mkCoq = version: callPackage ../applications/science/logic/coq {
    inherit version ocamlPackages_4_05 ocamlPackages_4_09 ocamlPackages_4_10;
  };
in rec {

  /* The function `mkCoqPackages` takes as input a derivation for Coq and produces
   * a set of libraries built with that specific Coq. More libraries are known to
   * this function than what is compatible with that version of Coq. Therefore,
   * libraries that are not known to be compatible are removed (filtered out) from
   * the resulting set. For meta-programming purposes (inpecting the derivations
   * rather than building the libraries) this filtering can be disabled by setting
   * a `dontFilter` attribute into the Coq derivation.
   */
  mkCoqPackages = coq:
    let self = lib.makeScope newScope (lib.flip mkCoqPackages' coq); in
    self.filterPackages (! coq.dontFilter or false);

  coq_8_5  = mkCoq "8.5";
  coq_8_6  = mkCoq "8.6";
  coq_8_7  = mkCoq "8.7";
  coq_8_8  = mkCoq "8.8";
  coq_8_9  = mkCoq "8.9";
  coq_8_10 = mkCoq "8.10";
  coq_8_11 = mkCoq "8.11";
  coq_8_12 = mkCoq "8.12";
  coq_8_13 = mkCoq "8.13";

  coqPackages_8_5 = mkCoqPackages coq_8_5;
  coqPackages_8_6 = mkCoqPackages coq_8_6;
  coqPackages_8_7 = mkCoqPackages coq_8_7;
  coqPackages_8_8 = mkCoqPackages coq_8_8;
  coqPackages_8_9 = mkCoqPackages coq_8_9;
  coqPackages_8_10 = mkCoqPackages coq_8_10;
  coqPackages_8_11 = mkCoqPackages coq_8_11;
  coqPackages_8_12 = mkCoqPackages coq_8_12;
  coqPackages_8_13 = mkCoqPackages coq_8_13;
  coqPackages = recurseIntoAttrs (lib.mapDerivationAttrset lib.dontDistribute
    coqPackages_8_11
  );
  coq = coqPackages.coq;

}
