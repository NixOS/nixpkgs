{ lib
, buildPythonPackage
, fetchPypi
, nbconvert
, path
, pytestCheckHook
, setuptools-scm
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "zetup";
  version = "0.2.64";

  # https://github.com/zimmermanncode/zetup/issues/4
  disabled = pythonAtLeast "3.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b8a9bdcfa4b705d72b55b218658bc9403c157db7b57a14158253c98d03ab713d";
  };

  # Python > 3.7 compatibility
  postPatch = ''
    substituteInPlace zetup/zetup_config.py \
      --replace "'3.7']" "'3.7', '3.8', '3.9', '3.10']"
  '';

  checkPhase = ''
    py.test test -k "not TestObject" --deselect=test/test_zetup_config.py::test_classifiers
  '';

  propagatedBuildInputs = [ setuptools-scm ];

  checkInputs = [
    path
    nbconvert
    pytestCheckHook
  ];

  pythonImportsCheck = [ "zetup" ];

  meta = with lib; {
    description = "Zimmermann's Extensible Tools for Unified Project setups";
    homepage = "https://github.com/zimmermanncode/zetup";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
