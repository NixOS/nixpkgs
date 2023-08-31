{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "turso-cli";
  version = "0.81.0";

  src = fetchFromGitHub {
    owner = "tursodatabase";
    repo = "turso-cli";
    rev = "v${version}";
    hash = "sha256-Ck1q3II/o7f+n0pdR5PzUXG2c6GZmQFeddofHzPTLlA=";
  };

  vendorHash = "sha256-Y/pg8+w6B1YQqaZ5wj8QZxiBHAG0Tf3Zec5WlVyA4eI=";

  # Test_setDatabasesCache fails due to /homeless-shelter: read-only file system error.
  doCheck = false;

  meta = with lib; {
    description = "This is the command line interface (CLI) to Turso.";
    homepage = "https://turso.tech";
    license = licenses.mit;
    maintainers = with maintainers; [zestsystem];
  };
}
