{ lib
, buildPythonPackage
, fetchFromGitHub

, hatch-fancy-pypi-readme
, hatch-vcs
, hatchling

, tenacity
, typing-extensions

, anyio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "stamina";
  version = "24.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hynek";
    repo = "stamina";
    rev = "refs/tags/${version}";
    hash = "sha256-DasubVqKRhX4CRyKyJ3fIA9Rxmy+kGxkW0pDdu8OPPo=";
  };

  nativeBuildInputs = [
    hatch-fancy-pypi-readme
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = [
    tenacity
    typing-extensions
  ];

  pythonImportsCheck = [ "stamina" ];

  nativeCheckInputs = [
    pytestCheckHook
    anyio
  ];

  meta = with lib; {
    description = "Production-grade retries for Python";
    homepage = "https://github.com/hynek/stamina";
    changelog = "https://github.com/hynek/stamina/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
