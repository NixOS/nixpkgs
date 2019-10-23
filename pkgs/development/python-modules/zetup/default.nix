{ stdenv, buildPythonPackage, fetchPypi
, setuptools_scm, pathpy, nbconvert
, pytest }:

buildPythonPackage rec {
  pname = "zetup";
  version = "0.2.64";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b8a9bdcfa4b705d72b55b218658bc9403c157db7b57a14158253c98d03ab713d";
  };

  # Python 3.7 compatibility
  # See https://github.com/zimmermanncode/zetup/pull/1
  postPatch = ''
    substituteInPlace zetup/zetup_config.py \
      --replace "'3.6']" "'3.6', '3.7']"
  '';

  checkPhase = ''
    py.test test -k "not TestObject" --deselect=test/test_zetup_config.py::test_classifiers
  '';

  checkInputs = [ pytest pathpy nbconvert ];
  propagatedBuildInputs = [ setuptools_scm ];

  meta = with stdenv.lib; {
    description = ''
      Zimmermann's Extensible Tools for Unified Project setups
    '';
    homepage = https://github.com/zimmermanncode/zetup;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
