{ lib
, buildPythonPackage
, isPy27
, fetchFromGitHub
, poetry-core
, requests
}:

buildPythonPackage rec {
  pname = "spiderpy";
  version = "1.7.1";
  format = "pyproject";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "peternijssen";
    repo = "spiderpy";
    rev = version;
    sha256 = "sha256-gQ/Y5c8+aSvoJzXI6eQ9rk0xDPxpi0xgO3xBKR+vVrY=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    requests
  ];

  # tests don't mock remote resources
  doCheck = false;

  pythonImportsCheck = [ "spiderpy.spiderapi" ];

  meta = with lib; {
    description = "Unofficial Python wrapper for the Spider API";
    homepage = "https://www.github.com/peternijssen/spiderpy";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
