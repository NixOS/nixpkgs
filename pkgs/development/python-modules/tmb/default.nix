{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
}:

buildPythonPackage rec {
  pname = "tmb";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "alemuro";
    repo = pname;
    rev = version;
    sha256 = "0fmwm9dz2mik9zni50wrnw7k9ld4l4w3p92aws6jcrdfxfi7aq7p";
  };

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
