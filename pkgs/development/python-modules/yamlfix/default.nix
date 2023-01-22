{ lib
, buildPythonPackage
, click
, fetchFromGitHub
, maison
, pdm-pep517
, pytest-xdist
, pytestCheckHook
, pythonOlder
, ruyaml
, setuptools
}:

buildPythonPackage rec {
  pname = "yamlfix";
  version = "1.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "lyz-code";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-TdW2vVj5wZw8xANSRY8ke1ECw8UTDwRjJDD1g+p9DV4=";
  };

  nativeBuildInputs = [
    setuptools
    pdm-pep517
  ];

  propagatedBuildInputs = [
    click
    maison
    ruyaml
  ];

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "yamlfix"
  ];

  meta = with lib; {
    description = "Python YAML formatter that keeps your comments";
    homepage = "https://github.com/lyz-code/yamlfix";
    changelog = "https://github.com/lyz-code/yamlfix/blob/${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ koozz ];
  };
}
