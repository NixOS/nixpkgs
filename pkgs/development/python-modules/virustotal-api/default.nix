{ lib
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "virustotal-api";
  version = "1.1.11";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nx14OoSOkop4qhaDcmRcaJnLvWuIiVHh1jNeW4feHD0=";
  };

  propagatedBuildInputs = [ requests ];

  # Tests are not in pypi
  doCheck = false;

  meta = {
    homepage = "https://pypi.org/project/virustotal-api";
    description = "Virus Total Public/Private/Intel API (deprecated)";
    maintainer = with lib.maintainers; [ jordanisaacs ];
    license = lib.licenses.mit;
  };
}
