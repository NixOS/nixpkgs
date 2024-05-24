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
  version = "0.5.1";
  format = "setuptools";
  disabled = pythonOlder "3.5";

  # Pypi does not contain unit tests
  src = fetchFromGitHub {
    owner = "djwooten";
    repo = "synergy";
    rev = "v${version}";
    sha256 = "1c60dpvr72g4wjqg6bc601kssl5z55v9bg09xbyh9ahch58bi212";
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
    description = "A Python library for calculating, analyzing, and visualizing drug combination synergy";
    homepage = "https://github.com/djwooten/synergy";
    maintainers = [ maintainers.ivar ];
    license = licenses.gpl3Plus;
  };
}
