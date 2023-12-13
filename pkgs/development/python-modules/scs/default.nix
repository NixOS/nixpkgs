{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, meson-python
, pkg-config
, Accelerate
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
    # needed for building against netlib's reference blas implementation and
    # the pkg-config patch. remove on next update
    (fetchpatch {
      name = "find-and-ld-lapack.patch";
      url = "https://github.com/bodono/scs-python/commit/a0aea80e7d490770d6a47d2c79396f6c3341c1f9.patch";
      hash = "sha256-yHF8f7SLoG7veZ6DEq1HVH6rT2KtFONwJtqSiKcxOdg=";
    })
    # add support for pkg-config. remove on next update
    (fetchpatch {
      name = "use-pkg-config.patch";
      url = "https://github.com/bodono/scs-python/commit/dd17e2e5282ebe85f2df8a7c6b25cfdeb894970d.patch";
      hash = "sha256-vSeSJeeu5Wx3RXPyB39YTo0RU8HtAojrUw85Q76/QzA=";
    })
  ];

  nativeBuildInputs = [
    meson-python
    pkg-config
  ];

  buildInputs = if stdenv.isDarwin then [
    Accelerate
  ] else [
    blas
    lapack
  ];

  propagatedBuildInputs = [
    numpy
    scipy
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "scs" ];
  disabledTests = lib.lists.optional (stdenv.system == "x86_64-linux") [
    # `test/test_scs_rand.py` hang on "x86_64-linux" (https://github.com/NixOS/nixpkgs/pull/244532#pullrequestreview-1598095858)
    "test_feasible"
    "test_infeasibl"
    "test_unbounded"
  ];

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
