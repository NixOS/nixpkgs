{
  lib,
  buildPythonPackage,
  construct,
  packaging,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "snapcast";
  version = "2.3.7";
  pyproject = true;

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

  meta = {
    description = "Control Snapcast, a multi-room synchronous audio solution";
    homepage = "https://github.com/happyleavesaoc/python-snapcast/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ peterhoeg ];
  };
}
