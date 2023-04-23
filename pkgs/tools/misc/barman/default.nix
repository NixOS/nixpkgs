{ lib
, fetchFromGitHub
, stdenv
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "barman";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "EnterpriseDB";
    repo = pname;
    rev = "refs/tags/release/${version}";
    hash = "sha256-K5y5C+K/fMhgOcSsCMaIgY6ce9UUPszoyumsfNHKjBo=";
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
    changelog = "https://github.com/EnterpriseDB/barman/blob/release/${version}/NEWS";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
