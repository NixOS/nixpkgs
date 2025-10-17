{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  xsdata,
  pydantic,
}:

buildPythonPackage rec {
  pname = "xsdata-pydantic";
  version = "24.5";
  pyproject = true;

  src = fetchPypi {
    pname = "xsdata_pydantic";
    inherit version;
    hash = "sha256-48h1gTMZVlfs5XhTftpsfr2EGfd6v2uQ/UztluNIEps=";
  };

  build-system = [ setuptools ];

  dependencies = [
    xsdata
    pydantic
  ];

  pythonImportsCheck = [
    "xsdata_pydantic"
  ];

  meta = with lib; {
    description = "Naive XML & JSON Bindings for python pydantic classes!";
    homepage = "https://github.com/tefra/xsdata-pydantic";
    maintainers = with maintainers; [ berrij ];
    license = licenses.mit;
    platforms = platforms.all;
  };
}
