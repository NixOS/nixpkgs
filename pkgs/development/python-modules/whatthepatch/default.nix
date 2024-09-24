{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "whatthepatch";
  version = "1.0.6";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cscorley";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-NjlQL+zgN9WKUMxMCl97eXTdM8Prrg3iiY8/zwQ8jyY=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "whatthepatch" ];

  meta = with lib; {
    description = "Python library for both parsing and applying patch files";
    homepage = "https://github.com/cscorley/whatthepatch";
    changelog = "https://github.com/cscorley/whatthepatch/blob/${version}/HISTORY.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
