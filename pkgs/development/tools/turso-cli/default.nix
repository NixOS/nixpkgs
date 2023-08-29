{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "turso-cli";
  version = "0.80.0";

  src = fetchFromGitHub {
    owner = "tursodatabase";
    repo = "turso-cli";
    rev = "v${version}";
    hash = "sha256-Q0H9Wq0QMh6rrEpfVdrU+e1wpcu1qE6t5d2PUBGsxRQ=";
  };

  vendorHash = "sha256-VbekKkS7cHe29O/YKIlxZ+BU9XSRlsBL06AKi2WelCs=";

  # Test_setDatabasesCache fails due to /homeless-shelter: read-only file system error.
  doCheck = false;

  meta = with lib; {
    description = "This is the command line interface (CLI) to Turso.";
    homepage = "https://turso.tech";
    license = licenses.mit;
    maintainers = with maintainers; [zestsystem];
  };
}
