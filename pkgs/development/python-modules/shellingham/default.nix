{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "shellingham";
  version = "1.5.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sarugaku";
    repo = "shellingham";
    tag = version;
    hash = "sha256-xeBo3Ok+XPrHN4nQd7M8/11leSV/8z1f7Sj33+HFVtQ=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "shellingham" ];

  meta = {
    description = "Tool to detect the surrounding shell";
    homepage = "https://github.com/sarugaku/shellingham";
    changelog = "https://github.com/sarugaku/shellingham/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ mbode ];
  };
}
