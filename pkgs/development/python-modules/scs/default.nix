{
  lib,
  stdenv,
  pkgs,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  meson-python,
  numpy,
  pkg-config,

  blas,
  lapack,

  # dependencies
  scipy,

  # check inputs
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "scs";
  inherit (pkgs.scs) version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bodono";
    repo = "scs-python";
    tag = version;
    fetchSubmodules = true;
    hash = "sha256-Dv0LDY6JFFq/dpcDsnU+ErnHJ8RDpaNhrRjEwY31Szk=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "numpy >= 2.0.0" "numpy"
  '';

  build-system = [
    meson-python
    numpy
    pkg-config
  ];

  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    blas
    lapack
  ];

  dependencies = [
    numpy
    scipy
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "scs" ];

  meta = {
    description = "Python interface for SCS: Splitting Conic Solver";
    longDescription = ''
      Solves convex cone programs via operator splitting.
      Can solve: linear programs (LPs), second-order cone programs (SOCPs), semidefinite programs (SDPs),
      exponential cone programs (ECPs), and power cone programs (PCPs), or problems with any combination of those cones.
    '';
    inherit (pkgs.scs.meta) homepage;
    downloadPage = "https://github.com/bodono/scs-python";
    changelog = "https://github.com/bodono/scs-python/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drewrisinger ];
  };
}
