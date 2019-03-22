{ stdenv, buildPythonPackage, fetchPypi
, setuptools_scm, pathpy, nbconvert
, pytest_3 }:

buildPythonPackage rec {
  pname = "zetup";
  version = "0.2.45";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f1cde33d0ef3bedaf697e432201fa86da698dadd3445c0efd2a114753853c675";
  };

  # Python 3.7 compatibility
  # See https://github.com/zimmermanncode/zetup/pull/1
  postPatch = ''
    substituteInPlace zetup/zetup_config.py \
      --replace "'3.6']" "'3.6', '3.7']"
  '';

  checkPhase = ''
    py.test test
  '';

  checkInputs = [ pytest_3 pathpy nbconvert ];
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
