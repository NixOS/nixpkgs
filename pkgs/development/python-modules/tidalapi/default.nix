{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, python-dateutil
, requests
}:

buildPythonPackage rec {
  pname = "tidalapi";
  version = "0.7.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LdlTBkCOb7tXiupsNJ5lbk38syKXeADvi2IdGpW/dk8=";
  };

  propagatedBuildInputs = [
    requests
    python-dateutil
  ];

  doCheck = false; # tests require internet access

  pythonImportsCheck = [
    "tidalapi"
  ];

  meta = with lib; {
    changelog = "https://github.com/tamland/python-tidal/releases/tag/v${version}";
    description = "Unofficial Python API for TIDAL music streaming service";
    homepage = "https://github.com/tamland/python-tidal";
    license = licenses.gpl3;
    maintainers = [ maintainers.rodrgz ];
  };
}
