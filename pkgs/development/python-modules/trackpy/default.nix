{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  setuptools,
  looseversion,
  matplotlib,
  numba,
  numpy,
  pandas,
  pytestCheckHook,
  pyyaml,
  scipy,
}:

buildPythonPackage (finalAttrs: {
  pname = "trackpy";
  version = "0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "soft-matter";
    repo = "trackpy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3e+gHdn/4n8T78eA3Gjz1TdSI4Hd935U2pqd8wG+U0M=";
  };

  patches = [
    (fetchpatch2 {
      name = "fix-complex-eigenvalues-numpy-2.5.patch";
      url = "https://github.com/soft-matter/trackpy/commit/5c4b5731f2f4695ca31de75f649c8c63b4c01026.patch?full_index=1";
      hash = "sha256-iMck90NNgNkf7t0Br/PoqnJ8beQIAO6srqhKxfZEeWw=";
    })
    (fetchpatch2 {
      name = "fix-applymap-pandas-2.1.0.patch";
      url = "https://github.com/soft-matter/trackpy/commit/3c406e9235d4b6293c45add84b45bd83cf18d5ca.patch?full_index=1";
      hash = "sha256-E59fp296maCVEPctadJLtaCF0O2NJ3b5ztCJd4e7vH4=";
    })
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    looseversion
    matplotlib
    numba
    numpy
    pandas
    pyyaml
    scipy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # specifically needed for darwin
    export HOME=$(mktemp -d)
    mkdir -p $HOME/.matplotlib
    echo "backend: ps" > $HOME/.matplotlib/matplotlibrc
  '';

  pythonImportsCheck = [ "trackpy" ];

  meta = {
    description = "Particle-tracking toolkit";
    homepage = "https://github.com/soft-matter/trackpy";
    changelog = "https://github.com/soft-matter/trackpy/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    broken = (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
  };
})
