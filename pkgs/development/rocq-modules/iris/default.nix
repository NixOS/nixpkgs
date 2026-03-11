{
  lib,
  mkRocqDerivation,
  stdlib,
  rocq-core,
  stdpp,
  version ? null,
}:

mkRocqDerivation {
  pname = "iris";
  domain = "gitlab.mpi-sws.org";
  owner = "iris";
  inherit version;
  defaultVersion =
    let
      case = case: out: { inherit case out; };
    in
    with lib.versions;
    lib.switch rocq-core.rocq-version [
      (case (range "9.0" "9.2") "4.5.0")
    ] null;
  release."4.5.0".sha256 = "sha256-oGqo+W1prLtAwRwo2U15VGhmrkDIPPE6uMbNrTa8iAQ=";
  releaseRev = v: "iris-${v}";

  propagatedBuildInputs = [
    stdlib
    stdpp
  ];

  preBuild = ''
    if [[ -f coq-lint.sh ]]
    then patchShebangs coq-lint.sh
    fi
  '';

  meta = {
    description = "Rocq development of the Iris Project";
    license = lib.licenses.bsd3;
    maintainers = [
      lib.maintainers.vbgl
      lib.maintainers.ineol
    ];
  };
}
