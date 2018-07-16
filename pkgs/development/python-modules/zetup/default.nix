{ stdenv, buildPythonPackage, fetchPypi
, setuptools_scm, pathpy, nbconvert
, pytest }:

buildPythonPackage rec {
  pname = "zetup";
  version = "0.2.43";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ee92ba93a03336962525536f237ae0decf99a9b5d484ba34a3cf06ef017dae8e";
  };

  checkPhase = ''
    py.test test
  '';

  checkInputs = [ pytest pathpy nbconvert ];
  propagatedBuildInputs = [ setuptools_scm ];

  meta = with stdenv.lib; {
    description = ''
      Zimmermann's Extensible Tools for Unified Project setups
    '';
    homepage = https://github.com/zimmermanncode/zetup;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
