{ lib, callPackage, newScope, recurseIntoAttrs
, gnumake3
, ocamlPackages_3_12_1
, ocamlPackages_4_02
}:

let
  mkCoqPackages' = self: coq:
    let callPackage = newScope self ; in rec {
      inherit callPackage coq;
      coqPackages = self;

      contribs = recurseIntoAttrs
        (callPackage ../development/coq-modules/contribs {});

      autosubst = callPackage ../development/coq-modules/autosubst {};
      bignums = if lib.versionAtLeast coq.coq-version "8.6"
        then callPackage ../development/coq-modules/bignums {}
        else null;
      category-theory = callPackage ../development/coq-modules/category-theory { };
      CoLoR = callPackage ../development/coq-modules/CoLoR {};
      coq-ext-lib = callPackage ../development/coq-modules/coq-ext-lib {};
      coq-haskell = callPackage ../development/coq-modules/coq-haskell { };
      coquelicot = callPackage ../development/coq-modules/coquelicot {};
      dpdgraph = callPackage ../development/coq-modules/dpdgraph {};
      equations = callPackage ../development/coq-modules/equations { };
      fiat_HEAD = callPackage ../development/coq-modules/fiat/HEAD.nix {};
      flocq = callPackage ../development/coq-modules/flocq {};
      heq = callPackage ../development/coq-modules/heq {};
      HoTT = callPackage ../development/coq-modules/HoTT {};
      interval = callPackage ../development/coq-modules/interval {};
      iris = callPackage ../development/coq-modules/iris {};
      math-classes = callPackage ../development/coq-modules/math-classes { };
      mathcomp = callPackage ../development/coq-modules/mathcomp { };
      metalib = callPackage ../development/coq-modules/metalib { };
      multinomials = callPackage ../development/coq-modules/multinomials {};
      paco = callPackage ../development/coq-modules/paco {};
      QuickChick = callPackage ../development/coq-modules/QuickChick {};
      ssreflect = callPackage ../development/coq-modules/ssreflect { };
      stdpp = callPackage ../development/coq-modules/stdpp { };
      tlc = callPackage ../development/coq-modules/tlc {};
    };

  filterCoqPackages = coq:
    lib.filterAttrsRecursive
    (_: p:
      let pred = p.compatibleCoqVersions or (_: true);
      in pred coq.coq-version
    );

in rec {

  mkCoqPackages = coq:
    let self = mkCoqPackages' self coq; in
    filterCoqPackages coq self;

  coq_8_3 = callPackage ../applications/science/logic/coq/8.3.nix {
    make = gnumake3;
    inherit (ocamlPackages_3_12_1) ocaml findlib;
    camlp5 = ocamlPackages_3_12_1.camlp5_transitional;
    lablgtk = ocamlPackages_3_12_1.lablgtk_2_14;
  };
  coq_8_4 = callPackage ../applications/science/logic/coq/8.4.nix {
    inherit (ocamlPackages_4_02) ocaml findlib lablgtk;
    camlp5 = ocamlPackages_4_02.camlp5_transitional;
  };
  coq_8_5 = callPackage ../applications/science/logic/coq {
    version = "8.5pl3";
  };
  coq_8_6 = callPackage ../applications/science/logic/coq {
    version = "8.6.1";
  };
  coq_8_7 = callPackage ../applications/science/logic/coq {
    version = "8.7.2";
  };
  coq_8_8 = callPackage ../applications/science/logic/coq {
    version = "8.8.1";
  };

  coqPackages_8_5 = mkCoqPackages coq_8_5;
  coqPackages_8_6 = mkCoqPackages coq_8_6;
  coqPackages_8_7 = mkCoqPackages coq_8_7;
  coqPackages_8_8 = mkCoqPackages coq_8_8;
  coqPackages = coqPackages_8_8;
  coq = coqPackages.coq;

}
