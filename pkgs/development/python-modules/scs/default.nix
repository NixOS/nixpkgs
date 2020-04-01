{ lib
, buildPythonPackage
, fetchFromGitHub
, blas
, liblapack
, numpy
, scipy
, scs
  # check inputs
, nose
}:

buildPythonPackage rec {
  inherit (scs) pname version;

  src = fetchFromGitHub {
    owner = "bodono";
    repo = "scs-python";
    rev = "f02abdc0e2e0a5851464e30f6766ccdbb19d73f0"; # need to choose commit manually, untagged
    sha256 = "174b5s7cwgrn1m55jlrszdl403zhpzc4yl9acs6kjv9slmg1mmjr";
  };

  preConfigure = ''
    rm -r scs
    ln -s ${scs.src} scs
  '';

  buildInputs = [
    liblapack
    blas
  ];

  propagatedBuildInputs = [
    numpy
    scipy
  ];

  checkInputs = [ nose ];
  checkPhase = ''
    nosetests
  '';
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
    license = licenses.gpl3;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
