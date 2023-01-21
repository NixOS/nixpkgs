{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, pytestCheckHook
, enrich
}:

buildPythonPackage rec {
  pname = "subprocess-tee";
  version = "0.4.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-s8EkmT+LiNHrHC/eC8IGl4fqxyC6iHccuhfoyTMkgl0=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytestCheckHook
    enrich
  ];

  disabledTests = [
    # cyclic dependency on `molecule` (see https://github.com/pycontribs/subprocess-tee/issues/50)
    "test_molecule"
    # duplicates in console output, rich issue
    "test_rich_console_ex"
  ];

  pythonImportsCheck = [
    "subprocess_tee"
  ];

  meta = with lib; {
    homepage = "https://github.com/pycontribs/subprocess-tee";
    description = "A subprocess.run drop-in replacement that supports a tee mode";
    license = licenses.mit;
    maintainers = with maintainers; [ putchar ];
  };
}
