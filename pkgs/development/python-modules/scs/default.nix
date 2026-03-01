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

buildPythonPackage (finalAttrs: {
  pname = "scs";
  inherit (pkgs.scs) version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bodono";
    repo = "scs-python";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-ZB1A6613ZgwGsZ97MpK9c1vUfNe+0RkUULtzQxGKd88=";
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
    changelog = "https://github.com/bodono/scs-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
