{ stdenv, buildPythonPackage, fetchPypi
, setuptools_scm, pathpy, nbconvert
, pytest }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "zetup";
  version = "0.2.42";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6c9e25249f3014ed2162398772ccf1a5e8a4e9e66c74e3c7f6683945a6a3d84c";
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
