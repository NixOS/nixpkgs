{
  lib,
  buildPythonPackage,
  cherrypy,
  fetchPypi,
  gevent,
  git,
  mock,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  tornado,
}:

buildPythonPackage rec {
  pname = "ws4py";
  version = "0.5.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KdBz1/LgBjc+aoSLHQCVGhEH64HzdClSvpBUKdxaVIM=";
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

  meta = with lib; {
    description = "WebSocket package for Python";
    homepage = "https://ws4py.readthedocs.org";
    changelog = "https://github.com/Lawouach/WebSocket-for-Python/blob/${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
