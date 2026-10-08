{
  lib,
  mkCoqDerivation,
  coq,
  stdlib,
  version ? null,
}:

mkCoqDerivation {
  pname = "rewriter";
  owner = "mit-plv";
  inherit version;
  defaultVersion =
    let
      case = case: out: { inherit case out; };
    in
    with lib.versions;
    lib.switch coq.coq-version [
      (case (range "8.17" "9.2") "0.0.15")
    ] null;
  release = {
    "0.0.15".hash = "sha256-zxNIMppFXUKShOXLbdZphy0Je5ii6cjcWUUcQMTcaHk=";
  };
  releaseRev = v: "v${v}";

  propagatedBuildInputs = [ stdlib ];

  mlPlugin = true;

  meta = {
    description = "Reflective PHOAS rewriting/pattern-matching-compilation framework for simply-typed equalities and let-lifting, experimental and tailored for use in Fiat Cryptography";
    license = lib.licenses.mit;
  };
}
