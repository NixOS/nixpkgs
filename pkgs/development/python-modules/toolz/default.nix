{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "toolz";
  version = "1.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LIbj2aBHmKxVZ5O87YOIFilqLwhQF2ZOSZXLQKEEegI=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # https://github.com/pytoolz/toolz/issues/577
    "test_inspect_wrapped_property"
  ];

  meta = with lib; {
    homepage = "https://github.com/pytoolz/toolz";
    changelog = "https://github.com/pytoolz/toolz/releases/tag/${version}";
    description = "List processing tools and functional utilities";
    license = licenses.bsd3;
  };
}
