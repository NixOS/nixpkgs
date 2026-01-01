{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "xboxapi";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mKeRix";
    repo = "xboxapi-python";
    tag = version;
    hash = "sha256-rX3lrXzUYqyRyI89fbCEEMevTdi5SBgSp8XxSanasII=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "xboxapi" ];

<<<<<<< HEAD
  meta = {
    description = "Python XBOX One API wrapper";
    homepage = "https://github.com/mKeRix/xboxapi-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python XBOX One API wrapper";
    homepage = "https://github.com/mKeRix/xboxapi-python";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
