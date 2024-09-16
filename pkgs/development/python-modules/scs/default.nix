{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  meson-python,
  numpy,
  pkg-config,

  # buildInputs
  Accelerate,
  blas,
  lapack,

  # dependencies
  scipy,

  # check inputs
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "scs";
  version = "3.2.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bodono";
    repo = "scs-python";
    rev = "refs/tags/${version}";
    hash = "sha256-ZhY4h0C8aF3IjD9NMtevcNTSqX+tIUao9bC+WlP+uDk=";
    fetchSubmodules = true;
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

  buildInputs =
    if stdenv.isDarwin then
      [ Accelerate ]
    else
      [
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
    homepage = "https://github.com/cvxgrp/scs"; # upstream C package
    downloadPage = "https://github.com/bodono/scs-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drewrisinger ];
  };
}
