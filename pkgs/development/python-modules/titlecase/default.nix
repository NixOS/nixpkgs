{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  regex,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "titlecase";
  version = "2.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ppannuto";
    repo = "python-titlecase";
    tag = "v${version}";
    hash = "sha256-aJbbfNnQvmmYPXVOO+xx7ADetsxE+jnVQOVDzV5jUp8=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ regex ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "titlecase/tests.py" ];

  pythonImportsCheck = [ "titlecase" ];

  meta = with lib; {
    description = "Python library to capitalize strings as specified by the New York Times";
    mainProgram = "titlecase";
    homepage = "https://github.com/ppannuto/python-titlecase";
    license = licenses.mit;
    maintainers = [ ];
  };
}
