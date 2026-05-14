{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "whoosh";
  version = "2.7.4";
  pyproject = true;

  src = fetchPypi {
    pname = "Whoosh";
    inherit version;
    hash = "sha256-fKVjPb+p4OD6QA0xUaigxL7FO9Ls7cCmdwWxdWXDGoM=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Wrong encoding
  postPatch = ''
    rm tests/test_reading.py
    substituteInPlace setup.cfg \
      --replace-fail "[pytest]" "[tool:pytest]"
  '';

  pythonImportsCheck = [ "whoosh" ];

  disabledTests = [ "test_minimize_dfa" ];

  meta = {
    description = "Fast, pure-Python full text indexing, search, and spell checking library";
    homepage = "https://github.com/mchaput/whoosh";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
