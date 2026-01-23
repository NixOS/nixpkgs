{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "ufonormalizer";
  version = "0.6.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-TFcVu5SDgfLGQa+CuUk4rSQtm1Nl3RxbfOPXVVaibDo=";
    extension = "zip";
  };

  nativeBuildInputs = [ setuptools-scm ];

  meta = {
    description = "Script to normalize the XML and other data inside of a UFO";
    mainProgram = "ufonormalizer";
    homepage = "https://github.com/unified-font-object/ufoNormalizer";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.sternenseemann ];
  };
}
