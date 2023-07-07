{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "tidyexc";
  version = "0.10.0";
  format = "flit";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1gl1jmihafawg7hvnn4xb20vd2x5qpvca0m1wr2gk0m2jj42yiq6";
  };

  pythonImportsCheck = [
    "tidyexc"
  ];

  meta = with lib; {
    description = "Raise rich, helpful exceptions";
    homepage = "https://github.com/kalekundert/tidyexc";
    changelog = "https://github.com/kalekundert/tidyexc/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
