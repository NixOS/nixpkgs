{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "yapps";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "smurfix";
    repo = "yapps";
    rev = "v${finalAttrs.version}";
    hash = "sha256-v4LqxIt7pi3FAUs8ZkPJiJ9cUWn8Rx7+GLwS8OFOf8E=";
    fetchSubmodules = true;
  };

  build-system = [ setuptools ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "yapps" ];

  meta = {
    description = "Parser generator, written in Python, generates Python code";
    homepage = "https://theory.stanford.edu/~amitp/yapps/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wucke13 ];
  };
})
