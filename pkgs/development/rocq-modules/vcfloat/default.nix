{
  lib,
  mkCoqDerivation,
  coq,
  interval,
  compcert,
  flocq,
  bignums,
  version ? null,
}:

let
  self = mkCoqDerivation {
    pname = "vcfloat";
    owner = "VeriNum";
    inherit version;
    sourceRoot = "${self.src.name}/vcfloat";
    postPatch = ''
      coq_makefile -o Makefile -f _CoqProject *.v
    '';
    defaultVersion =
      with lib.versions;
      lib.switch coq.coq-version [
        {
          case = range "9.0" "9.2";
          out = "2.4.2";
        }
        {
          case = isEq "8.20";
          out = "2.3";
        }
        {
          case = isEq "8.19";
          out = "2.2";
        }
        {
          case = range "8.16" "8.18";
          out = "2.1.1";
        }
      ] null;
    release."2.4.2".hash = "sha256-IpsPFEWSlCPtZ3LwikhE4Z+/ICqCpbC6GZAXCQxy7w8=";
    release."2.4.1".hash = "sha256-AVm4Gj1vxus0Jqvpy5uX5Zy21X1wEMXcqikWAdxEJCk=";
    release."2.4".hash = "sha256-jA0Ch/efxg2VL9+lFj3JVq+fKhiwMkPUMvGZF2HGPVY=";
    release."2.3".hash = "sha256-fV7w/kYTpcBxrHFzEvx+eydDHbGH05/seucrgSjKK3w=";
    release."2.2".hash = "sha256-PyMm84ZYh+dOnl8Kk2wlYsQ+S/d1Hsp6uv2twTedEPg=";
    release."2.1.1".hash = "sha256-bd/XSQhyFUAnSm2bhZEZBWB6l4/Ptlm9JrWu6w9BOpw=";
    release."2.1".hash = "sha256-6h0oA1nnKX2MDOpdLPw1+0zJ7sPBEcyPzkSnsFNZkN8=";
    # The 2.1 tag, unlike the later ones, has no v prefix.
    release."2.1".rev = "2.1";
    releaseRev = v: "v${v}";

    propagatedBuildInputs = [
      interval
      compcert
      flocq
      bignums
    ];

    meta = {
      description = "Tool for Coq proofs about floating-point round-off error";
      maintainers = with lib.maintainers; [ quinn-dougherty ];
      license = lib.licenses.lgpl3Plus;
    };
  };
in
self
