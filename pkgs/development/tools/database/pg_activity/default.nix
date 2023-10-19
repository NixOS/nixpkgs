{ python3Packages, fetchFromGitHub, lib }:

python3Packages.buildPythonApplication rec {
  pname = "pg_activity";
  version = "3.0.3";
  disabled = python3Packages.pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "dalibo";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-djpBdhCgtlm6+DiZVKSKh0nu30YVm/qZHlBHPtdObfU=";
  };

  propagatedBuildInputs = with python3Packages; [
    attrs
    blessed
    humanize
    psutil
    psycopg2
  ];

  pythonImportsCheck = [ "pgactivity" ];

  meta = with lib; {
    description = "A top like application for PostgreSQL server activity monitoring";
    homepage = "https://github.com/dalibo/pg_activity";
    license = licenses.postgresql;
    maintainers = with maintainers; [ mausch ];
  };
}
