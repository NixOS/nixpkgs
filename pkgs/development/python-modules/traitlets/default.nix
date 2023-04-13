{ lib
, buildPythonPackage
, fetchPypi
, glibcLocales
, pytest
, mock
, ipython_genutils
, decorator
, pythonOlder
, six
, hatchling
}:

buildPythonPackage rec {
  pname = "traitlets";
  version = "5.9.0";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9s3iGpxoz3Vq8CA19y1acjv2B+hi574z7OUFq/Sjutk=";
  };

  nativeBuildInputs = [ hatchling ];
  nativeCheckInputs = [ glibcLocales pytest mock ];
  propagatedBuildInputs = [ ipython_genutils decorator six ];

  checkPhase = ''
    LC_ALL="en_US.UTF-8" py.test
  '';

  meta = {
    description = "Traitlets Python config system";
    homepage = "https://ipython.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
