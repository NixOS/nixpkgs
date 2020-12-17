{ lib, buildPythonPackage, fetchPypi, pythonOlder, setuptools_scm }:

buildPythonPackage rec {
  pname = "ufonormalizer";
  version = "0.5.0";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1qc3389i2y16n1hjg4dzk821klzjipbh9c9yci70z51pp21mwwh5";
    extension = "zip";
  };

  nativeBuildInputs = [ setuptools_scm ];

  meta = with lib; {
    description = "Script to normalize the XML and other data inside of a UFO";
    homepage = "https://github.com/unified-font-object/ufoNormalizer";
    license = licenses.bsd3;
    maintainers = [ maintainers.sternenseemann ];
  };
}
