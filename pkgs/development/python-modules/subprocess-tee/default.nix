{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, pytestCheckHook
, enrich
}:

buildPythonPackage rec {
  pname = "subprocess-tee";
  version = "0.3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ff5cced589a4b8ac973276ca1ba21bb6e3de600cde11a69947ff51f696efd577";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  checkInputs = [
    pytestCheckHook
    enrich
  ];

  disabledTests = [
    # cyclic dependency on `molecule` (see https://github.com/pycontribs/subprocess-tee/issues/50)
    "test_molecule"
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
