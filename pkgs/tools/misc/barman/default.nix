{ fetchFromGitHub
, lib
, python3Packages
}:
python3Packages.buildPythonApplication rec {
  pname = "barman";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "EnterpriseDB";
    repo = pname;
    rev = "release/${version}";
    sha256 = "sha256-WLKtra1kNxvm4iO3NEhMNCSioHL9I8GIgkbtu95IyTQ=";
  };

  checkInputs = with python3Packages; [
    mock
    python-snappy
    google-cloud-storage
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

  disabledTests = [
    # Assertion error
    "test_help_output"
  ];

  meta = with lib; {
    homepage = "https://www.pgbarman.org/";
    description = "Backup and Recovery Manager for PostgreSQL";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
