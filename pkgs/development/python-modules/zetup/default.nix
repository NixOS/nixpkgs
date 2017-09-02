{ stdenv, buildPythonPackage, fetchPypi
, setuptools_scm, pathpy, nbconvert
, pytest }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "zetup";
  version = "0.2.34";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0k4lm51b5qjy7yxy3n5z8vc5hlvjcsfsvwjgqzkr0pisysar1kpf";
  };

  checkPhase = ''
    py.test test
  '';

  buildInputs = [ pytest pathpy nbconvert ];
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
