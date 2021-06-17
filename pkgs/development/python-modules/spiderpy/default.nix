{ lib
, buildPythonPackage
, isPy27
, fetchFromGitHub
, requests
}:

buildPythonPackage rec {
  pname = "spiderpy";
  version = "1.5.0";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "peternijssen";
    repo = "spiderpy";
    rev = version;
    sha256 = "1nbfjqwiyyl7lhkb4rvickxiy9nwynr2sxr1hpyv0vm09h6q8hsc";
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
