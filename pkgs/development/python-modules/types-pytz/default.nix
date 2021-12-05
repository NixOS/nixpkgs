{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "types-pytz";
  version = "2021.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-3/138+/s07FVXxh6m/OmONVfrClnALgpxBvVHscqbrc=";
  };

  # Modules doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "pytz-stubs" ];

  meta = with lib; {
    description = "Typing stubs for pytz";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
