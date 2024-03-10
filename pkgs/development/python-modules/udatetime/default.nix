{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "udatetime";
  version = "0.0.17";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sQvFVwaZpDinLitaZOdr2MKO4779FvIJOHpVB/oLgwE=";
  };

  # tests not included on pypi
  doCheck = false;

  pythonImportsCheck = [ "udatetime" ];

  meta = with lib; {
    description = "Fast RFC3339 compliant Python date-time library";
    homepage = "https://github.com/freach/udatetime";
    license = licenses.asl20;
    maintainers = with maintainers; [ globin ];
  };
}
