{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
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
