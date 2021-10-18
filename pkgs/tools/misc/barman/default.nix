{ buildPythonApplication
, fetchFromGitHub
, lib
, mock
, pytest
, pytest-runner
, python-dateutil
, argcomplete
, argh
, azure-identity
, azure-storage-blob
, psycopg2
, boto3
}:

buildPythonApplication rec {
  pname = "barman";
  version = "2.15";

  src = fetchFromGitHub {
    owner = "EnterpriseDB";
    repo = pname;
    rev = "release/${version}";
    sha256 = "127cqndg0405rad9jzba1mfhpqmyfa3kx16w345kd4n822w17ak9";
  };

  checkInputs = [
    mock
    pytest
    pytest-runner
  ];

  propagatedBuildInputs = [
    argcomplete
    argh
    azure-identity
    azure-storage-blob
    boto3
    psycopg2
    python-dateutil
  ];

  meta = with lib; {
    homepage = "https://www.pgbarman.org/";
    description = "Backup and Recovery Manager for PostgreSQL";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
