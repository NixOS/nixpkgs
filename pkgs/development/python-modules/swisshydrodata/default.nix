{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, requests
, requests-mock
}:

buildPythonPackage rec {
  pname = "swisshydrodata";
  version = "0.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Bouni";
    repo = pname;
    rev = version;
    sha256 = "1rdgfc6zg5j3fvrpbqs9vc3n5m66r5yljawyl7nmrqd5lwq1lqak";
  };

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "swisshydrodata" ];

  meta = with lib; {
    description = "Python client to get data from the Swiss federal Office for Environment FEON";
    homepage = "https://github.com/bouni/swisshydrodata";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
