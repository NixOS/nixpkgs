{
  buildPythonPackage,
  lib,
  fetchPypi,
  setuptools,
  setuptools-scm,
  glibcLocales,
  isPy3k,
  pytestCheckHook,
  curio,
}:

buildPythonPackage rec {
  pname = "sniffio";
  version = "1.3.1";
  pyproject = true;

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9DJO3GcKD0l1CoG4lfNcOtuEPMpG8FMPefwbq7I3idw=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  buildInputs = [ glibcLocales ];

  nativeCheckInputs = [
    curio
    pytestCheckHook
  ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/python-trio/sniffio";
    license = lib.licenses.asl20;
=======
  meta = with lib; {
    homepage = "https://github.com/python-trio/sniffio";
    license = licenses.asl20;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Sniff out which async library your code is running under";
  };
}
