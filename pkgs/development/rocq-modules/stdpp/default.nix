{
  lib,
  mkRocqDerivation,
  rocq-core,
  stdlib,
  version ? null,
}:

mkRocqDerivation {
  pname = "stdpp";
  inherit version;
  domain = "gitlab.mpi-sws.org";
  owner = "iris";
  defaultVersion =
    let
      case = case: out: { inherit case out; };
    in
    with lib.versions;
    lib.switch rocq-core.rocq-version [
      (case (range "9.0" "9.2") "1.13.0")
    ] null;
  release."1.13.0".sha256 = "sha256-kj8oBzarsLB4DDQ43yz4ViQbyzuISqext28wC2Fh3Sw=";
  releaseRev = v: "stdpp-${v}";

  propagatedBuildInputs = [ stdlib ];

  preBuild = ''
    if [[ -f coq-lint.sh ]]
    then patchShebangs coq-lint.sh
    fi
  '';

  meta = {
    description = "Extended “Standard Library” for Rocq";
    license = lib.licenses.bsd3;
    maintainers = [
      lib.maintainers.vbgl
      lib.maintainers.ineol
    ];
  };
}
