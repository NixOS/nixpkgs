{
  lib,
  mkRocqDerivation,
  rocq-core,
  stdlib,
  version ? null,
}:

mkRocqDerivation {
  pname = "bignums";
  owner = "rocq-community";
  inherit version;
  defaultVersion =
    let
      case = case: out: { inherit case out; };
    in
    with lib.versions;
    lib.switch rocq-core.rocq-version [
      (case (range "9.0" "9.1") "9.0.0+rocq${rocq-core.rocq-version}")
    ] null;

  release."9.0.0+rocq9.0".sha256 = "sha256-ctnwpyNVhryEUA5YEsAImrcJsNMhtBgDSOz+z5Z4R78=";
  release."9.0.0+rocq9.1".sha256 = "sha256-MSjlfJs3JOakuShOj+isNlus0bKlZ+rkvzRoKZQK5RQ=";
  releaseRev = v: "v${v}";

  mlPlugin = true;

  propagatedBuildInputs = [ stdlib ];

  meta = {
    license = lib.licenses.lgpl2;
  };
}
