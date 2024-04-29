{ lib, stdenv, fetchzip
, callPackage, newScope, recurseIntoAttrs, ocamlPackages_4_05, ocamlPackages_4_09
, ocamlPackages_4_10, ocamlPackages_4_12, ocamlPackages_4_14
, fetchpatch, makeWrapper, coq2html
}@args:
let lib = import ../build-support/coq/extra-lib.nix {inherit (args) lib;}; in
let
  mkCoqPackages' = self: coq:
    let callPackage = self.callPackage; in {
      inherit coq lib;
      coqPackages = self // { coqPackages = self.coqPackages // { recurseForDerivations = false; }; };

      metaFetch = import ../build-support/coq/meta-fetch/default.nix
        {inherit lib stdenv fetchzip; };
      mkCoqDerivation = lib.makeOverridable (callPackage ../build-support/coq {});

      contribs = recurseIntoAttrs
        (callPackage ../development/coq-modules/contribs {});

      aac-tactics = callPackage ../development/coq-modules/aac-tactics {};
      addition-chains = callPackage ../development/coq-modules/addition-chains {};
      autosubst = callPackage ../development/coq-modules/autosubst {};
      bignums = if lib.versionAtLeast coq.coq-version "8.6"
        then callPackage ../development/coq-modules/bignums {}
        else null;
      category-theory = callPackage ../development/coq-modules/category-theory { };
      ceres = callPackage ../development/coq-modules/ceres {};
      Cheerios = callPackage ../development/coq-modules/Cheerios {};
      CoLoR = callPackage ../development/coq-modules/CoLoR (
        (lib.optionalAttrs (lib.versions.isEq self.coq.coq-version "8.13") {
          bignums = self.bignums.override { version = "8.13.0"; };
        })
      );
      compcert = callPackage ../development/coq-modules/compcert {
        inherit fetchpatch makeWrapper coq2html lib stdenv;
        ocamlPackages = ocamlPackages_4_14;
      };
      coq-bits = callPackage ../development/coq-modules/coq-bits {};
      coq-elpi = callPackage ../development/coq-modules/coq-elpi {};
      coq-ext-lib = callPackage ../development/coq-modules/coq-ext-lib {};
      coq-haskell = callPackage ../development/coq-modules/coq-haskell { };
      coq-lsp = callPackage ../development/coq-modules/coq-lsp {};
      coq-record-update = callPackage ../development/coq-modules/coq-record-update { };
      coqeal = callPackage ../development/coq-modules/coqeal (
        (lib.optionalAttrs (lib.versions.range "8.13" "8.14" self.coq.coq-version) {
          bignums = self.bignums.override { version = "${self.coq.coq-version}.0"; };
        })
      );
      coqhammer = callPackage ../development/coq-modules/coqhammer {};
      coqide = callPackage ../development/coq-modules/coqide {};
      coqprime = callPackage ../development/coq-modules/coqprime {};
      coqtail-math = callPackage ../development/coq-modules/coqtail-math {};
      coquelicot = callPackage ../development/coq-modules/coquelicot {};
      corn = callPackage ../development/coq-modules/corn {};
      deriving = callPackage ../development/coq-modules/deriving {};
      dpdgraph = callPackage ../development/coq-modules/dpdgraph {};
      equations = callPackage ../development/coq-modules/equations { };
      extructures = callPackage ../development/coq-modules/extructures { };
      fiat_HEAD = callPackage ../development/coq-modules/fiat/HEAD.nix {};
      flocq = callPackage ../development/coq-modules/flocq {};
      fourcolor = callPackage ../development/coq-modules/fourcolor {};
      gaia = callPackage ../development/coq-modules/gaia {};
      gaia-hydras = callPackage ../development/coq-modules/gaia-hydras {};
      gappalib = callPackage ../development/coq-modules/gappalib {};
      goedel = callPackage ../development/coq-modules/goedel {};
      graph-theory = callPackage ../development/coq-modules/graph-theory {};
      heq = callPackage ../development/coq-modules/heq {};
      hierarchy-builder = callPackage ../development/coq-modules/hierarchy-builder {};
      HoTT = callPackage ../development/coq-modules/HoTT {};
      hydra-battles = callPackage ../development/coq-modules/hydra-battles {};
      interval = callPackage ../development/coq-modules/interval {};
      InfSeqExt = callPackage ../development/coq-modules/InfSeqExt {};
      iris = callPackage ../development/coq-modules/iris {};
      iris-named-props = callPackage ../development/coq-modules/iris-named-props {};
      itauto = callPackage ../development/coq-modules/itauto { };
      ITree = callPackage ../development/coq-modules/ITree { };
      LibHyps = callPackage ../development/coq-modules/LibHyps {};
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
      mathcomp-algebra-tactics = callPackage ../development/coq-modules/mathcomp-algebra-tactics {};
      mathcomp-analysis = callPackage ../development/coq-modules/mathcomp-analysis {};
      mathcomp-apery = callPackage ../development/coq-modules/mathcomp-apery {};
      mathcomp-bigenough = callPackage ../development/coq-modules/mathcomp-bigenough {};
      mathcomp-classical = self.mathcomp-analysis.classical;
      mathcomp-finmap = callPackage ../development/coq-modules/mathcomp-finmap {};
      mathcomp-infotheo = callPackage ../development/coq-modules/mathcomp-infotheo {};
      mathcomp-real-closed = callPackage ../development/coq-modules/mathcomp-real-closed {};
      mathcomp-tarjan = callPackage ../development/coq-modules/mathcomp-tarjan {};
      mathcomp-word = callPackage ../development/coq-modules/mathcomp-word {};
      mathcomp-zify = callPackage ../development/coq-modules/mathcomp-zify {};
      metacoq = callPackage ../development/coq-modules/metacoq { };
      metacoq-template-coq = self.metacoq.template-coq;
      metacoq-pcuic        = self.metacoq.pcuic;
      metacoq-safechecker  = self.metacoq.safechecker;
      metacoq-erasure      = self.metacoq.erasure;
      metalib = callPackage ../development/coq-modules/metalib { };
      multinomials = callPackage ../development/coq-modules/multinomials {};
      odd-order = callPackage ../development/coq-modules/odd-order { };
      paco = callPackage ../development/coq-modules/paco {};
      paramcoq = callPackage ../development/coq-modules/paramcoq {};
      parsec = callPackage ../development/coq-modules/parsec {};
      pocklington = callPackage ../development/coq-modules/pocklington {};
      QuickChick = callPackage ../development/coq-modules/QuickChick {};
      reglang = callPackage ../development/coq-modules/reglang {};
      relation-algebra = callPackage ../development/coq-modules/relation-algebra {};
      semantics = callPackage ../development/coq-modules/semantics {};
      serapi = callPackage ../development/coq-modules/serapi {};
      simple-io = callPackage ../development/coq-modules/simple-io { };
      smpl = callPackage ../development/coq-modules/smpl { };
      smtcoq = callPackage ../development/coq-modules/smtcoq { };
      stdpp = callPackage ../development/coq-modules/stdpp { };
      StructTact = callPackage ../development/coq-modules/StructTact {};
      tlc = callPackage ../development/coq-modules/tlc {};
      topology = callPackage ../development/coq-modules/topology {};
      trakt = callPackage ../development/coq-modules/trakt {};
      vcfloat = callPackage ../development/coq-modules/vcfloat (lib.optionalAttrs
        (lib.versions.range "8.16" "8.18" self.coq.version) {
          interval = self.interval.override { version = "4.9.0"; };
        });
      Velisarios = callPackage ../development/coq-modules/Velisarios {};
      Verdi = callPackage ../development/coq-modules/Verdi {};
      Vpl = callPackage ../development/coq-modules/Vpl {};
      VplTactic = callPackage ../development/coq-modules/VplTactic {};
      vscoq-language-server = callPackage ../development/coq-modules/vscoq-language-server {};
      VST = callPackage ../development/coq-modules/VST ((lib.optionalAttrs
        (lib.versionAtLeast self.coq.version "8.14") {
          compcert = self.compcert.override {
            version = with lib.versions; lib.switch self.coq.version [
              { case = range "8.15" "8.17"; out = "3.13.1"; }
              { case = isEq "8.14"; out = "3.11"; }
            ] null;
          };
        }) // (lib.optionalAttrs (lib.versions.isEq self.coq.coq-version "8.13") {
          ITree = self.ITree.override {
            version = "4.0.0";
            paco = self.paco.override { version = "4.1.2"; };
          };
       }));
      zorns-lemma = callPackage ../development/coq-modules/zorns-lemma {};
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
    inherit version
      ocamlPackages_4_05
      ocamlPackages_4_09
      ocamlPackages_4_10
      ocamlPackages_4_12
      ocamlPackages_4_14
    ;
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
  coq_8_14 = mkCoq "8.14";
  coq_8_15 = mkCoq "8.15";
  coq_8_16 = mkCoq "8.16";
  coq_8_17 = mkCoq "8.17";
  coq_8_18 = mkCoq "8.18";
  coq_8_19 = mkCoq "8.19";

  coqPackages_8_5 = mkCoqPackages coq_8_5 // { __attrsFailEvaluation = true; };
  coqPackages_8_6 = mkCoqPackages coq_8_6 // { __attrsFailEvaluation = true; };
  coqPackages_8_7 = mkCoqPackages coq_8_7 // { __attrsFailEvaluation = true; };
  coqPackages_8_8 = mkCoqPackages coq_8_8 // { __attrsFailEvaluation = true; };
  coqPackages_8_9 = mkCoqPackages coq_8_9 // { __attrsFailEvaluation = true; };
  coqPackages_8_10 = mkCoqPackages coq_8_10 // { __attrsFailEvaluation = true; };
  coqPackages_8_11 = mkCoqPackages coq_8_11 // { __attrsFailEvaluation = true; };
  coqPackages_8_12 = mkCoqPackages coq_8_12 // { __attrsFailEvaluation = true; };
  coqPackages_8_13 = mkCoqPackages coq_8_13 // { __attrsFailEvaluation = true; };
  coqPackages_8_14 = mkCoqPackages coq_8_14 // { __attrsFailEvaluation = true; };
  coqPackages_8_15 = mkCoqPackages coq_8_15 // { __attrsFailEvaluation = true; };
  coqPackages_8_16 = mkCoqPackages coq_8_16 // { __attrsFailEvaluation = true; };
  coqPackages_8_17 = mkCoqPackages coq_8_17 // { __attrsFailEvaluation = true; };
  coqPackages_8_18 = mkCoqPackages coq_8_18 // { __attrsFailEvaluation = true; };
  coqPackages_8_19 = mkCoqPackages coq_8_19 // { __attrsFailEvaluation = true; };
  coqPackages =
    let cp = recurseIntoAttrs coqPackages_8_18;
    in cp // { coqPackages = cp.coqPackages // { __attrsFailEvaluation = true; }; } // { __recurseIntoDerivationForReleaseJobs = true; };
  coq = coqPackages.coq;

}
