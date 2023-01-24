{ fetchFromGitHub
, lib
, stdenv
, python3Packages
}:
python3Packages.buildPythonApplication rec {
  pname = "barman";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "EnterpriseDB";
    repo = pname;
    rev = "refs/tags/release/${version}";
    sha256 = "sha256-4mbu3Z48jZQqRft4vkz/x4a7kAOiTrQfnyQpXl3MJn0=";
  };

  patches = [
    ./unwrap-subprocess.patch
  ];

  nativeCheckInputs = with python3Packages; [
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
  ] ++ lib.optionals stdenv.isDarwin [
    # FsOperationFailed
    "test_get_file_mode"
  ];

  meta = with lib; {
    homepage = "https://www.pgbarman.org/";
    description = "Backup and Recovery Manager for PostgreSQL";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
