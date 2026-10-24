{
  lib,
  mkCoqDerivation,
  coq,
  mathcomp-boot,
  ExtLib,
  simple-io,
  version ? null,
}:

(mkCoqDerivation {
  pname = "QuickChick";
  owner = "QuickChick";
  inherit version;
  defaultVersion =
    let
      case = coq: mc: out: {
        cases = [
          coq
          mc
        ];
        inherit out;
      };
    in
    lib.switch
      [ coq.coq-version mathcomp-boot.version ]
      [
        (case (lib.versions.range "9.0" "9.2") lib.pred.true "2.2.0")
        (case (lib.versions.range "8.20" "9.1") lib.pred.true "2.1.1")
        (case (lib.versions.range "8.13" "8.16") lib.pred.true "1.6.5")
        (case "8.13" lib.pred.true "1.5.0")
        (case "8.12" lib.pred.true "1.4.0")
        (case "8.11" lib.pred.true "1.3.2")
        (case "8.10" lib.pred.true "1.2.1")
        (case "8.9" lib.pred.true "1.1.0")
      ]
      null;
  release."2.2.0".hash = "sha256-uVOYyl0xZXlxQthU78mQxZTy5tJfmay8KUz9koIpAFk=";
  release."2.1.1".hash = "sha256-tcZFpf8joEdVCgy1oKWdaM/9q3EMsF/jT+zz+kIsix8=";
  release."2.0.4".hash = "sha256-WD8B+n8gyGctHMO+M8201Ca3Uw8zCWYsOatSNGCf0/s=";
  release."2.0.2".hash = "sha256-xxKkwDRjB8nUiXNhein1Ppn0DP5FZ13J90xUPAnQBbs=";
  release."2.0.1".hash = "sha256-gJc+9Or6tbqE00920Il4pnEvokRoiADX6CxP/Q0QZaY=";
  release."1.6.5".hash = "sha256-rcFyRDH8UbB9KVk10P5qjtPkWs04p78VNHkCq4mXr3U=";
  release."1.6.4".hash = "sha256-C1060wPSU33yZAFLxGmZlAMXASnx98qz3oSLO8DO+mM=";
  release."1.6.2".hash = "sha256:0g5q9zw3xd4zndihq96nxkq4w3dh05418wzlwdk1nnn3b6vbx6z0";
  release."1.5.0".hash = "sha256:1lq8x86vd3vqqh2yq6hvyagpnhfq5wmk5pg2z0xq7b7dcw7hyfkw";
  release."1.4.0".hash = "sha256:068p48pm5yxjc3yv8qwzp25bp9kddvxj81l31mjkyx3sdrsw3kyc";
  release."1.3.2".hash = "sha256:0lciwaqv288dh2f13xk2x0lrn6zyrkqy6g4yy927wwzag2gklfrs";
  release."1.2.1".hash = "sha256:17vz88xjzxh3q7hs6hnndw61r3hdfawxp5awqpgfaxx4w6ni8z46";
  release."1.1.0".hash = "sha256:1c34v1k37rk7v0xk2czv5n79mbjxjrm6nh3llg2mpfmdsqi68wf3";
  releaseRev = v: "v${v}";

  preConfigure = "substituteInPlace Makefile --replace quickChickTool.byte quickChickTool.native";

  useDuneifVersion = v: lib.versions.isGe "2.1" v || v == "dev";
  opam-name = "coq-quickchick";

  mlPlugin = true;
  nativeBuildInputs = [ coq.ocamlPackages.ocamlbuild ];
  propagatedBuildInputs = [
    mathcomp-boot
    ExtLib
    simple-io
  ];
  extraInstallFlags = [ "-f Makefile.coq" ];

  enableParallelBuilding = false;

  meta = {
    description = "Randomized property-based testing plugin for Coq; a clone of Haskell QuickCheck";
    maintainers = with lib.maintainers; [ jwiegley ];
  };
}).overrideAttrs
  (
    o:
    let
      after_1_6 = lib.versions.isGe "1.6" o.version || o.version == "dev";
      after_2_1 = lib.versions.isGe "2.1" o.version || o.version == "dev";
    in
    {
      nativeBuildInputs =
        o.nativeBuildInputs
        ++ lib.optional after_1_6 coq.ocamlPackages.cppo
        ++ lib.optional after_2_1 coq.ocamlPackages.menhir;
      propagatedBuildInputs =
        o.propagatedBuildInputs
        ++ lib.optionals after_1_6 (
          with coq.ocamlPackages;
          [
            findlib
            zarith
          ]
        );
    }
  )
