{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
}:

buildPythonPackage rec {
  pname = "tuyaha";
  version = "0.0.11";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "PaulAnnekov";
    repo = pname;
    rev = version;
    hash = "sha256-PTIw/2NRHHiqV6E5oj2pMeGq1uApevKfT2n5zV8AQmM=";
  };

  propagatedBuildInputs = [ requests ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "tuyaha" ];

  meta = with lib; {
    description = "Python module with the Tuya API";
    homepage = "https://github.com/PaulAnnekov/tuyaha";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
