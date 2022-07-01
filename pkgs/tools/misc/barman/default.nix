{ fetchFromGitHub
, lib
, python3Packages
}:
python3Packages.buildPythonApplication rec {
  pname = "barman";
  version = "2.17";

  src = fetchFromGitHub {
    owner = "EnterpriseDB";
    repo = pname;
    rev = "release/${version}";
    sha256 = "0c4gcs4kglbb2qma4nlvw0ycj1wnsg934p9vs50dvqi9099hxkmb";
  };

  checkInputs = with python3Packages; [
    mock
    pytestCheckHook
  ];

  propagatedBuildInputs = with python3Packages; [
    argcomplete
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
