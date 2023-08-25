{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "turso-cli";
  version = "0.79.0";

  src = fetchFromGitHub {
    owner = "tursodatabase";
    repo = "turso-cli";
    rev = "v${version}";
    hash = "sha256-5ucStAFe3lZgnGMI0fRw1E4T60+9nglNbZnzrjRmRgk=";
  };

  vendorHash = "sha256-+F9I6+f7Sm5qhBAoXCMKjV/jFY0fyVIk0NKBQNNI+qM=";

  # Test_setDatabasesCache fails due to /homeless-shelter: read-only file system error.
  doCheck = false;

  meta = with lib; {
    description = "This is the command line interface (CLI) to Turso.";
    homepage = "https://turso.tech";
    license = licenses.mit;
    maintainers = with maintainers; [zestsystem];
  };
}
