{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
}:

buildPythonPackage rec {
  pname = "tmb";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "alemuro";
    repo = pname;
    rev = version;
    sha256 = "sha256-xwzaJuiQxExUA5W4kW7t1713S6NOvDNagcD3/dwA+DE=";
  };

  VERSION = version;

  propagatedBuildInputs = [ requests ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "tmb" ];

  meta = with lib; {
    homepage = "https://github.com/alemuro/tmb";
    description = "Python library that interacts with TMB API";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
