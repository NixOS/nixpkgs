{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
}:

buildPythonPackage rec {
  pname = "tuyaha";
  version = "0.0.10";

  src = fetchFromGitHub {
    owner = "PaulAnnekov";
    repo = pname;
    rev = version;
    sha256 = "0n08mqrz76zv1cyqky6ibs6im1fqcywkiyvfmfabml0vzvr43awf";
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
