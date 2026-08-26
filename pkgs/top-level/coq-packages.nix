{
  lib,
  stdenv,
  fetchurl,
  fetchzip,
  callPackage,
  newScope,
  ocamlPackages_4_09,
  ocamlPackages_4_10,
  ocamlPackages_4_12,
  ocamlPackages_4_14,
  ocamlPackages_5_5,
  rocqPackages_9_0,
  rocqPackages_9_1,
  rocqPackages_9_2,
  rocqPackages_9_3,
  rocqPackages,
  fetchpatch,
  makeWrapper,
  coq2html,
  dune,
}@args:
let
  lib = import ../build-support/coq/extra-lib.nix { inherit (args) lib; };
in
let
  mkCoqPackages' =
    self: coq:
    let
      callPackage = self.callPackage;
      rocqPackages = self // {
        recurseForDerivations = false;
      };
    in
    {
      inherit rocqPackages lib;

      metaFetch = import ../build-support/rocq/meta-fetch/default.nix {
        inherit
          lib
          stdenv
          fetchzip
          fetchurl
          ;
      };
      mkRocqDerivation = lib.makeOverridable (callPackage ../build-support/rocq { });
      mkCoqDerivation =
        args:
        self.mkRocqDerivation (
          {
            useCoq = true;
            namePrefix = [ "coq" ];
          }
          // args
        );

      coq = coq.overrideAttrs (oldAttrs: {
        passthru = (oldAttrs.passthru or { }) // {
          withPackages =
            f:
            (callPackage ../applications/science/logic/coq/with-packages.nix {
              inherit coq;
            })
              (f self);
        };
      });

      rocq-core = coq;

      contribs = lib.recurseIntoAttrs (callPackage ../development/rocq-modules/contribs { });

      aac-tactics = callPackage ../development/rocq-modules/aac-tactics { };
      addition-chains = callPackage ../development/rocq-modules/addition-chains { };
      async-test = callPackage ../development/rocq-modules/async-test { };
      atbr = callPackage ../development/rocq-modules/atbr { };
      autosubst = callPackage ../development/rocq-modules/autosubst { };
      autosubst-ocaml = callPackage ../development/rocq-modules/autosubst-ocaml { };
      bbv = callPackage ../development/rocq-modules/bbv { };
      bignums = callPackage ../development/rocq-modules/bignums { };
      CakeMLExtraction = callPackage ../development/rocq-modules/CakeMLExtraction { };
      category-theory = callPackage ../development/rocq-modules/category-theory { };
      ceres = callPackage ../development/rocq-modules/ceres { };
      ceres-bs = callPackage ../development/rocq-modules/ceres-bs { };
      CertiRocq = callPackage ../development/rocq-modules/CertiRocq { };
      Cheerios = callPackage ../development/rocq-modules/Cheerios { };
      coinduction = callPackage ../development/rocq-modules/coinduction { };
      CoLoR = callPackage ../development/rocq-modules/CoLoR (
        lib.optionalAttrs (lib.versions.isEq self.coq.coq-version "8.13") {
          bignums = self.bignums.override { version = "8.13.0"; };
        }
      );
      compcert = callPackage ../development/rocq-modules/compcert {
        inherit
          fetchpatch
          makeWrapper
          coq2html
          lib
          stdenv
          ;
      };
      ConCert = callPackage ../development/rocq-modules/ConCert { };
      coq-bits = callPackage ../development/rocq-modules/coq-bits { };
      coq-elpi = callPackage ../development/rocq-modules/coq-elpi { };
      rocq-elpi = callPackage ../development/rocq-modules/coq-elpi { };
      coq-hammer = callPackage ../development/rocq-modules/coq-hammer { };
      coq-hammer-tactics = callPackage ../development/rocq-modules/coq-hammer/tactics.nix { };
      CoqMatrix = callPackage ../development/rocq-modules/coq-matrix { };
      coq-haskell = callPackage ../development/rocq-modules/coq-haskell { };
      coq-lsp = callPackage ../development/rocq-modules/coq-lsp { };
      coq-record-update = callPackage ../development/rocq-modules/coq-record-update { };
      coq-tactical = callPackage ../development/rocq-modules/coq-tactical { };
      coqeal = callPackage ../development/rocq-modules/coqeal (
        lib.optionalAttrs (lib.versions.range "8.13" "8.14" self.coq.coq-version) {
          bignums = self.bignums.override { version = "${self.coq.coq-version}.0"; };
        }
      );
      coqhammer = callPackage ../development/rocq-modules/coqhammer { };
      coqide = callPackage ../development/rocq-modules/coqide { };
      coqprime = callPackage ../development/rocq-modules/coqprime { };
      coqtail-math = callPackage ../development/rocq-modules/coqtail-math { };
      coquelicot = callPackage ../development/rocq-modules/coquelicot { };
      coqutil = callPackage ../development/rocq-modules/coqutil { };
      coqfmt = callPackage ../development/rocq-modules/coqfmt { };
      corn = callPackage ../development/rocq-modules/corn { };
      deriving = callPackage ../development/rocq-modules/deriving { };
      dpdgraph = callPackage ../development/rocq-modules/dpdgraph { };
      ElmExtraction = callPackage ../development/rocq-modules/ElmExtraction { };
      equations = callPackage ../development/rocq-modules/equations { };
      ExtLib = callPackage ../development/rocq-modules/ExtLib { };
      extructures = callPackage ../development/rocq-modules/extructures { };
      fcsl-pcm = callPackage ../development/rocq-modules/fcsl-pcm { };
      flocq = callPackage ../development/rocq-modules/flocq { };
      fourcolor = callPackage ../development/rocq-modules/fourcolor { };
      gaia = callPackage ../development/rocq-modules/gaia { };
      gaia-hydras = callPackage ../development/rocq-modules/gaia-hydras { };
      gappalib = callPackage ../development/rocq-modules/gappalib { };
      goedel = callPackage ../development/rocq-modules/goedel { };
      graph-theory = callPackage ../development/rocq-modules/graph-theory { };
      heq = callPackage ../development/rocq-modules/heq { };
      hierarchy-builder = callPackage ../development/rocq-modules/hierarchy-builder { };
      high-school-geometry = callPackage ../development/rocq-modules/high-school-geometry { };
      HoTT = callPackage ../development/rocq-modules/HoTT { };
      http = callPackage ../development/rocq-modules/http { };
      hydra-battles = callPackage ../development/rocq-modules/hydra-battles { };
      interval = callPackage ../development/rocq-modules/interval { };
      InfSeqExt = callPackage ../development/rocq-modules/InfSeqExt { };
      iris = callPackage ../development/rocq-modules/iris { };
      iris-named-props = callPackage ../development/rocq-modules/iris-named-props { };
      itauto = callPackage ../development/rocq-modules/itauto { };
      ITree = callPackage ../development/rocq-modules/ITree { };
      itree-io = callPackage ../development/rocq-modules/itree-io { };
      jasmin = callPackage ../development/rocq-modules/jasmin { };
      json = callPackage ../development/rocq-modules/json { };
      lemma-overloading = callPackage ../development/rocq-modules/lemma-overloading { };
      LibHyps = callPackage ../development/rocq-modules/LibHyps { };
      libvalidsdp = self.validsdp.libvalidsdp;
      ltac2 = callPackage ../development/rocq-modules/ltac2 { };
      math-classes = callPackage ../development/rocq-modules/math-classes { };
      mathcomp = callPackage ../development/rocq-modules/mathcomp { };
      ssreflect = self.mathcomp.ssreflect;
      mathcomp-boot = self.mathcomp.boot;
      mathcomp-order = self.mathcomp.order;
      mathcomp-ssreflect = self.mathcomp.ssreflect;
      mathcomp-finite-group = self.mathcomp.finite-group;
      mathcomp-fingroup = self.mathcomp.finite-group;
      mathcomp-algebra = self.mathcomp.algebra;
      mathcomp-solvable = self.mathcomp.solvable;
      mathcomp-field = self.mathcomp.field;
      mathcomp-group-representation = self.mathcomp.group-representation;
      mathcomp-character = self.mathcomp.group-representation;
      mathcomp-abel = callPackage ../development/rocq-modules/mathcomp-abel { };
      mathcomp-algebra-tactics = callPackage ../development/rocq-modules/mathcomp-algebra-tactics { };
      mathcomp-analysis = callPackage ../development/rocq-modules/mathcomp-analysis { };
      mathcomp-analysis-stdlib = self.mathcomp-analysis.analysis-stdlib;
      mathcomp-apery = callPackage ../development/rocq-modules/mathcomp-apery { };
      mathcomp-bigenough = callPackage ../development/rocq-modules/mathcomp-bigenough { };
      mathcomp-classical = self.mathcomp-analysis.classical;
      mathcomp-experimental-reals = self.mathcomp-analysis.experimental-reals;
      mathcomp-finmap = callPackage ../development/rocq-modules/mathcomp-finmap { };
      mathcomp-infotheo = callPackage ../development/rocq-modules/mathcomp-infotheo { };
      mathcomp-real-closed = callPackage ../development/rocq-modules/mathcomp-real-closed { };
      mathcomp-reals = self.mathcomp-analysis.reals;
      mathcomp-reals-stdlib = self.mathcomp-analysis.reals-stdlib;
      mathcomp-tarjan = callPackage ../development/rocq-modules/mathcomp-tarjan { };
      mathcomp-word = callPackage ../development/rocq-modules/mathcomp-word { };
      mathcomp-zify = callPackage ../development/rocq-modules/mathcomp-zify { };
      MenhirLib = callPackage ../development/rocq-modules/MenhirLib { };
      metacoq = callPackage ../development/rocq-modules/metacoq { };
      metacoq-utils = self.metacoq.utils;
      metacoq-common = self.metacoq.common;
      metacoq-template-coq = self.metacoq.template-coq;
      metacoq-pcuic = self.metacoq.pcuic;
      metacoq-safechecker = self.metacoq.safechecker;
      metacoq-template-pcuic = self.metacoq.template-pcuic;
      metacoq-erasure = self.metacoq.erasure;
      metacoq-quotation = self.metacoq.quotation;
      metacoq-safechecker-plugin = self.metacoq.safechecker-plugin;
      metacoq-erasure-plugin = self.metacoq.erasure-plugin;
      metacoq-translations = self.metacoq.translations;
      metalib = callPackage ../development/rocq-modules/metalib { };
      metarocq = callPackage ../development/rocq-modules/metarocq { };
      metarocq-utils = self.metarocq.utils;
      metarocq-common = self.metarocq.common;
      metarocq-template-rocq = self.metarocq.template-rocq;
      metarocq-pcuic = self.metarocq.pcuic;
      metarocq-safechecker = self.metarocq.safechecker;
      metarocq-template-pcuic = self.metarocq.template-pcuic;
      metarocq-erasure = self.metarocq.erasure;
      metarocq-quotation = self.metarocq.quotation;
      metarocq-safechecker-plugin = self.metarocq.safechecker-plugin;
      metarocq-erasure-plugin = self.metarocq.erasure-plugin;
      metarocq-translations = self.metarocq.translations;
      mtac2 = callPackage ../development/rocq-modules/mtac2 { };
      multinomials = callPackage ../development/rocq-modules/multinomials { };
      odd-order = callPackage ../development/rocq-modules/odd-order { };
      Ordinal = callPackage ../development/rocq-modules/Ordinal { };
      paco = callPackage ../development/rocq-modules/paco { };
      paramcoq = callPackage ../development/rocq-modules/paramcoq { };
      parsec = callPackage ../development/rocq-modules/parsec { };
      parseque = callPackage ../development/rocq-modules/parseque { };
      pocklington = callPackage ../development/rocq-modules/pocklington { };
      QuickChick = callPackage ../development/rocq-modules/QuickChick { };
      reglang = callPackage ../development/rocq-modules/reglang { };
      relation-algebra = callPackage ../development/rocq-modules/relation-algebra { };
      rewriter = callPackage ../development/rocq-modules/rewriter { };
      RustExtraction = callPackage ../development/rocq-modules/RustExtraction { };
      semantics = callPackage ../development/rocq-modules/semantics { };
      serapi = callPackage ../development/rocq-modules/serapi { };
      simple-io = callPackage ../development/rocq-modules/simple-io { };
      smpl = callPackage ../development/rocq-modules/smpl { };
      smtcoq = callPackage ../development/rocq-modules/smtcoq { };
      ssprove = callPackage ../development/rocq-modules/ssprove { };
      stalmarck-tactic = callPackage ../development/rocq-modules/stalmarck { };
      stalmarck = self.stalmarck-tactic.stalmarck;
      stdlib = callPackage ../development/rocq-modules/stdlib { };
      stdpp = callPackage ../development/rocq-modules/stdpp { };
      StructTact = callPackage ../development/rocq-modules/StructTact { };
      tlc = callPackage ../development/rocq-modules/tlc { };
      topology = callPackage ../development/rocq-modules/topology { };
      trakt = callPackage ../development/rocq-modules/trakt { };
      TypedExtraction = callPackage ../development/rocq-modules/TypedExtraction { };
      TypedExtraction-common = self.TypedExtraction.common;
      TypedExtraction-elm = self.TypedExtraction.elm;
      TypedExtraction-rust = self.TypedExtraction.rust;
      TypedExtraction-plugin = self.TypedExtraction.plugin;
      unicoq = callPackage ../development/rocq-modules/unicoq { };
      validsdp = callPackage ../development/rocq-modules/validsdp { };
      vcfloat = callPackage ../development/rocq-modules/vcfloat (
        lib.optionalAttrs (lib.versions.range "8.16" "8.18" self.coq.version) {
          interval = self.interval.override { version = "4.9.0"; };
        }
      );
      Velisarios = callPackage ../development/rocq-modules/Velisarios { };
      Verdi = callPackage ../development/rocq-modules/Verdi { };
      verified-extraction = callPackage ../development/rocq-modules/verified-extraction { };
      Vpl = callPackage ../development/rocq-modules/Vpl { };
      VplTactic = callPackage ../development/rocq-modules/VplTactic { };
      vscoq-language-server = callPackage ../development/rocq-modules/vscoq-language-server { };
      vsrocq-language-server = callPackage ../development/rocq-modules/vsrocq-language-server { };
      VST = callPackage ../development/rocq-modules/VST (
        (lib.optionalAttrs (lib.versionAtLeast self.coq.version "8.14") {
          compcert = self.compcert.override {
            version =
              with lib.versions;
              lib.switch self.coq.version [
                {
                  case = range "8.15" "8.18";
                  out = "3.13.1";
                }
                {
                  case = isEq "8.14";
                  out = "3.11";
                }
              ] null;
          };
        })
        // (lib.optionalAttrs (lib.versions.isEq self.coq.coq-version "8.13") {
          ITree = self.ITree.override {
            version = "4.0.0";
            paco = self.paco.override { version = "4.1.2"; };
          };
        })
      );
      wasmcert = callPackage ../development/rocq-modules/wasmcert { };
      waterproof = callPackage ../development/rocq-modules/waterproof { };
      zorns-lemma = callPackage ../development/rocq-modules/zorns-lemma { };
      filterPackages = doesFilter: if doesFilter then filterCoqPackages self else self;
    };

  filterCoqPackages =
    set:
    lib.listToAttrs (
      lib.concatMap (
        name:
        let
          v = set.${name} or null;
        in
        lib.optional (!v.meta.rocqFilter or false) (
          lib.nameValuePair name (
            if lib.isAttrs v && v.recurseForDerivations or false then filterCoqPackages v else v
          )
        )
      ) (lib.attrNames set)
    );
  mkCoq =
    version: rp:
    callPackage ../applications/science/logic/coq {
      inherit
        version
        ocamlPackages_4_09
        ocamlPackages_4_10
        ocamlPackages_4_12
        ocamlPackages_4_14
        ocamlPackages_5_5
        ;
      rocqPackages = rp;
    };
in
rec {

  /*
    The function `mkCoqPackages` takes as input a derivation for Coq and produces
    a set of libraries built with that specific Coq. More libraries are known to
    this function than what is compatible with that version of Coq. Therefore,
    libraries that are not known to be compatible are removed (filtered out) from
    the resulting set. For meta-programming purposes (inspecting the derivations
    rather than building the libraries) this filtering can be disabled by setting
    a `dontFilter` attribute into the Coq derivation.
  */
  mkCoqPackages =
    coq:
    let
      self = lib.makeScope newScope (lib.flip mkCoqPackages' coq);
    in
    self.filterPackages (!coq.dontFilter or false);

  coqPackages_8_7 = mkCoqPackages (mkCoq "8.7" { });
  coqPackages_8_8 = mkCoqPackages (mkCoq "8.8" { });
  coqPackages_8_9 = mkCoqPackages (mkCoq "8.9" { });
  coqPackages_8_10 = mkCoqPackages (mkCoq "8.10" { });
  coqPackages_8_11 = mkCoqPackages (mkCoq "8.11" { });
  coqPackages_8_12 = mkCoqPackages (mkCoq "8.12" { });
  coqPackages_8_13 = mkCoqPackages (mkCoq "8.13" { });
  coqPackages_8_14 = mkCoqPackages (mkCoq "8.14" { });
  coqPackages_8_15 = mkCoqPackages (mkCoq "8.15" { });
  coqPackages_8_16 = mkCoqPackages (mkCoq "8.16" { });
  coqPackages_8_17 = mkCoqPackages (mkCoq "8.17" { });
  coqPackages_8_18 = mkCoqPackages (mkCoq "8.18" { });
  coqPackages_8_19 = mkCoqPackages (mkCoq "8.19" { });
  coqPackages_8_20 = mkCoqPackages (mkCoq "8.20" { });

  coq_8_7 = coqPackages_8_7.coq;
  coq_8_8 = coqPackages_8_8.coq;
  coq_8_9 = coqPackages_8_9.coq;
  coq_8_10 = coqPackages_8_10.coq;
  coq_8_11 = coqPackages_8_11.coq;
  coq_8_12 = coqPackages_8_12.coq;
  coq_8_13 = coqPackages_8_13.coq;
  coq_8_14 = coqPackages_8_14.coq;
  coq_8_15 = coqPackages_8_15.coq;
  coq_8_16 = coqPackages_8_16.coq;
  coq_8_17 = coqPackages_8_17.coq;
  coq_8_18 = coqPackages_8_18.coq;
  coq_8_19 = coqPackages_8_19.coq;
  coq_8_20 = coqPackages_8_20.coq;

}
