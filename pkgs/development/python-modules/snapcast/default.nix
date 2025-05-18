{
  lib,
  buildPythonPackage,
  construct,
  packaging,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "snapcast";
  version = "2.3.7";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "happyleavesaoc";
    repo = "python-snapcast";
    tag = version;
    hash = "sha256-k6U13vkeOAip94hcEjssFgvMnhpOXG87E0R2Zu1YyY4=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    construct
    packaging
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "snapcast" ];

  disabledTests = [
    # AssertionError and TypeError
    "test_stream_setmeta"
    "est_stream_setproperty"
  ];

  meta = with lib; {
    description = "Control Snapcast, a multi-room synchronous audio solution";
    homepage = "https://github.com/happyleavesaoc/python-snapcast/";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
