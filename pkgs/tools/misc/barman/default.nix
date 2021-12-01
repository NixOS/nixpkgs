{ fetchFromGitHub
, lib
, python3Packages
}:
python3Packages.buildPythonApplication rec {
  pname = "barman";
  version = "2.15";

  src = fetchFromGitHub {
    owner = "EnterpriseDB";
    repo = pname;
    rev = "release/${version}";
    sha256 = "127cqndg0405rad9jzba1mfhpqmyfa3kx16w345kd4n822w17ak9";
  };

  checkInputs = with python3Packages; [
    mock
    pytestCheckHook
  ];

  propagatedBuildInputs = with python3Packages; [
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
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
