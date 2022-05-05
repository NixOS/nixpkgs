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
  version = "0.8.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "lyz-code";
    repo = pname;
    rev = version;
    sha256 = "sha256-YCC4xK1fB5Gyv32JhbSuejtzLNMRnH7iyUpzccVijS0=";
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
