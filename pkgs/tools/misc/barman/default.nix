{ fetchFromGitHub
, lib
, python39Packages
}:
let 
  pythonPackages = python39Packages;
in
pythonPackages.buildPythonApplication rec {
  pname = "barman";
  version = "2.15";

  src = fetchFromGitHub {
    owner = "EnterpriseDB";
    repo = pname;
    rev = "release/${version}";
    sha256 = "127cqndg0405rad9jzba1mfhpqmyfa3kx16w345kd4n822w17ak9";
  };

  checkInputs = with pythonPackages; [ 
    mock
    pytestCheckHook 
  ];

  propagatedBuildInputs = with pythonPackages; [
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
