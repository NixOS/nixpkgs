{ lib, buildPythonPackage, fetchPypi, pythonOlder, setuptools-scm }:

buildPythonPackage rec {
  pname = "ufonormalizer";
  version = "0.6.0";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0w44qlvg4xks7jb0lf3lhsbylagq956x0wkcal9ix34bz3p7vdxd";
    extension = "zip";
  };

  nativeBuildInputs = [ setuptools-scm ];

  meta = with lib; {
    description = "Script to normalize the XML and other data inside of a UFO";
    homepage = "https://github.com/unified-font-object/ufoNormalizer";
    license = licenses.bsd3;
    maintainers = [ maintainers.sternenseemann ];
  };
}
