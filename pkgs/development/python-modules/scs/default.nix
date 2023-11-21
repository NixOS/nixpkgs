{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, meson-python
, pkg-config
, blas
, lapack
, numpy
, scipy
  # check inputs
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "scs";
  version = "3.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bodono";
    repo = "scs-python";
    rev = version;
    hash = "sha256-UmMbnj7QZSvHWSUk1Qa0VP4i3iDCYHxoa+qBmEdFjRs=";
    fetchSubmodules = true;
  };

  patches = [
    # don't use Accelerate on darwin
    ./meson.diff
  ];

  nativeBuildInputs = [
    meson-python
    pkg-config
  ];

  buildInputs = [
    blas
    lapack
  ];

  propagatedBuildInputs = [
    numpy
    scipy
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "scs" ];

  meta = with lib; {
    description = "Python interface for SCS: Splitting Conic Solver";
    longDescription = ''
      Solves convex cone programs via operator splitting.
      Can solve: linear programs (LPs), second-order cone programs (SOCPs), semidefinite programs (SDPs),
      exponential cone programs (ECPs), and power cone programs (PCPs), or problems with any combination of those cones.
    '';
    homepage = "https://github.com/cvxgrp/scs"; # upstream C package
    downloadPage = "https://github.com/bodono/scs-python";
    license = licenses.mit;
    maintainers = with maintainers; [ a-n-n-a-l-e-e drewrisinger ];
  };
}
