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
    hash = "sha256-5hEQ51pQAIPyZThbE1S1eGEPlULju77tuYoqYVXkqmw=";
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
