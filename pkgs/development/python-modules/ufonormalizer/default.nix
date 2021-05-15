{ lib, buildPythonPackage, fetchPypi, pythonOlder, setuptools_scm }:

buildPythonPackage rec {
  pname = "ufonormalizer";
  version = "0.5.3";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ijc697nv9rff9j1nhbf5vnyaryxlndq13msi94px8aq9gzxfrbi";
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
