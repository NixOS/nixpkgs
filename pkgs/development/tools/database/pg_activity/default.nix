{ python3Packages, fetchFromGitHub, lib }:

python3Packages.buildPythonApplication rec {
  pname = "pg_activity";
  version = "3.0.0";
  disabled = python3Packages.pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "dalibo";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-MJZS5+i3s5fTFcgw5zt3GeJKKZ/GS66scuUAW9Fu73A=";
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
