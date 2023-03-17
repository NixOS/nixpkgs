{ lib
, buildPythonPackage
, fetchFromGitHub
, blas
, lapack
, numpy
, scipy
  # check inputs
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "scs";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "bodono";
    repo = "scs-python";
    rev = version;
    sha256 = "sha256-7OgqCo21S0FDev8xv6/8iGFXg8naVi93zd8v1f9iaWw=";
    fetchSubmodules = true;
  };

  buildInputs = [
    lapack
    blas
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
    maintainers = with maintainers; [ drewrisinger ];
  };
}
