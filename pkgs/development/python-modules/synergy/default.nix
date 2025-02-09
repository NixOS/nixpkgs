{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  numpy,
  scipy,
  matplotlib,
  plotly,
  pandas,
}:

buildPythonPackage rec {
  pname = "synergy";
  version = "1.0.0";
  format = "setuptools";
  disabled = pythonOlder "3.5";

  # Pypi does not contain unit tests
  src = fetchFromGitHub {
    owner = "djwooten";
    repo = "synergy";
    tag = "v${version}";
    sha256 = "sha256-df5CBEcRx55/rSMc6ygMVrHbbEcnU1ISJheO+WoBSCI=";
  };

  propagatedBuildInputs = [
    numpy
    scipy
    matplotlib
    plotly
    pandas
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "synergy" ];

  meta = with lib; {
    description = "Python library for calculating, analyzing, and visualizing drug combination synergy";
    homepage = "https://github.com/djwooten/synergy";
    maintainers = [ ];
    license = licenses.gpl3Plus;
  };
}
