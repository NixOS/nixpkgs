{ lib
, buildPythonPackage
, click
, fetchFromGitHub
, pytest-xdist
, pytestCheckHook
, pythonOlder
, ruyaml
}:

buildPythonPackage rec {
  pname = "yamlfix";
  version = "0.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "lyz-code";
    repo = pname;
    rev = version;
    sha256 = "sha256-Gkq80YMeiPy7xxLauA/nloW4znMV2tfE+e24HyZgUaQ=";
  };

  propagatedBuildInputs = [
    click
    ruyaml
  ];

  checkInputs = [
    pytest-xdist
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'python_paths = "."' ""
  '';

  pytestFlagsArray = [
    "-n"
    "$NIX_BUILD_CORES"
  ];

  pythonImportsCheck = [
    "yamlfix"
  ];

  meta = with lib; {
    description = "Python YAML formatter that keeps your comments";
    homepage = "https://github.com/lyz-code/yamlfix";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ koozz ];
  };
}
