{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  looseversion,
  matplotlib,
  numba,
  numpy,
  pandas,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  scipy,
}:

buildPythonPackage rec {
  pname = "trackpy";
  version = "0.7";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "soft-matter";
    repo = "trackpy";
    tag = "v${version}";
    hash = "sha256-3e+gHdn/4n8T78eA3Gjz1TdSI4Hd935U2pqd8wG+U0M=";
  };

  propagatedBuildInputs = [
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

  meta = with lib; {
    description = "Particle-tracking toolkit";
    homepage = "https://github.com/soft-matter/trackpy";
    changelog = "https://github.com/soft-matter/trackpy/releases/tag/${src.tag}";
    license = licenses.bsd3;
    maintainers = [ ];
    broken = (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
  };
}
