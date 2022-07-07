{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, regex
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "titlecase";
  version = "2.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ppannuto";
    repo = "python-titlecase";
    rev = "v${version}";
    sha256 = "169ywzn5wfzwyknqavspkdpwbx31nycxsxkl7iywwk71gs1lskkw";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    regex
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "titlecase/tests.py"
  ];

  pythonImportsCheck = [
    "titlecase"
  ];

  meta = with lib; {
    description = "Python library to capitalize strings as specified by the New York Times";
    homepage = "https://github.com/ppannuto/python-titlecase";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
