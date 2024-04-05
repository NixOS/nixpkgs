{ python3Packages, fetchFromGitHub, lib }:

python3Packages.buildPythonApplication rec {
  pname = "pg_activity";
  version = "3.5.0";
  disabled = python3Packages.pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "dalibo";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-raEQbpADSkJZu+ULxzJg9GqFQ4/qmONDHGqoc7quMjI=";
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
    mainProgram = "pg_activity";
    homepage = "https://github.com/dalibo/pg_activity";
    license = licenses.postgresql;
    maintainers = with maintainers; [ mausch ];
  };
}
