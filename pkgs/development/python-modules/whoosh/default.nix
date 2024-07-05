{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "whoosh";
  version = "2.7.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Whoosh";
    inherit version;
    hash = "sha256-fKVjPb+p4OD6QA0xUaigxL7FO9Ls7cCmdwWxdWXDGoM=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Wrong encoding
  postPatch = ''
    rm tests/test_reading.py
    substituteInPlace setup.cfg \
      --replace-fail "[pytest]" "[tool:pytest]"
  '';

  pythonImportsCheck = [ "whoosh" ];

  disabledTests = [ "test_minimize_dfa" ];

  meta = with lib; {
    description = "Fast, pure-Python full text indexing, search, and spell checking library";
    homepage = "https://github.com/mchaput/whoosh";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
