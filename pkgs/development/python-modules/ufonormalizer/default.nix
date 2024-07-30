{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "ufonormalizer";
  version = "0.6.1";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e61110e75a500083f265385b1354b578610f9542e3bbbeedb98a2a6155e4aa6c";
    extension = "zip";
  };

  nativeBuildInputs = [ setuptools-scm ];

  meta = with lib; {
    description = "Script to normalize the XML and other data inside of a UFO";
    mainProgram = "ufonormalizer";
    homepage = "https://github.com/unified-font-object/ufoNormalizer";
    license = licenses.bsd3;
    maintainers = [ maintainers.sternenseemann ];
  };
}
