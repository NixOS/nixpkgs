{
  lib,
  buildPythonPackage,
  cherrypy,
  fetchPypi,
  gevent,
  git,
  mock,
  pytestCheckHook,
  setuptools,
  tornado,
}:

buildPythonPackage rec {
  pname = "ws4py";
  version = "0.6.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-n4exm3c/CgdEo486+jaoAyht0xl/C7Ndm3UpPscALRk=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    cherrypy
    gevent
    tornado
  ];

  nativeCheckInputs = [
    git
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "ws4py" ];

  meta = {
    description = "WebSocket package for Python";
    homepage = "https://ws4py.readthedocs.org";
    changelog = "https://github.com/Lawouach/WebSocket-for-Python/blob/${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
