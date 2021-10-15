{ lib
, buildPythonPackage
, isPy27
, fetchFromGitHub
, requests
}:

buildPythonPackage rec {
  pname = "spiderpy";
  version = "1.6.1";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "peternijssen";
    repo = "spiderpy";
    rev = version;
    sha256 = "sha256-x8G9qjwmLL/Iom+YAADue5lt63lfEKj80zau1+0zHsI=";
  };

  propagatedBuildInputs = [
    requests
  ];

  # no unit tests implemented
  doCheck = false;

  pythonImportsCheck = [ "spiderpy.spiderapi" ];

  meta = with lib; {
    description = "Unofficial Python wrapper for the Spider API";
    homepage = "https://www.github.com/peternijssen/spiderpy";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
