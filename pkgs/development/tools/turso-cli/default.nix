{
  lib,
  buildGo121Module,
  fetchFromGitHub,
}:
buildGo121Module rec {
  pname = "turso-cli";
  version = "0.85.1";

  src = fetchFromGitHub {
    owner = "tursodatabase";
    repo = "turso-cli";
    rev = "v${version}";
    hash = "sha256-3JyAvxIKDVifGNJ5uOiIcaCvZ3U8u1fdvT6Xmvksnzc=";
  };

  vendorHash = "sha256-OiLb+aLZfTLtxNWBJYyyrFXBGbsGKS5rjP+P6RQ94wE=";

  # Build with production code
  tags = ["prod"];
  # Include version for `turso --version` reporting
  preBuild = ''
    echo "v${version}" > internal/cmd/version.txt
  '';

  # Test_setDatabasesCache fails due to /homeless-shelter: read-only file system error.
  doCheck = false;

  meta = with lib; {
    description = "This is the command line interface (CLI) to Turso.";
    homepage = "https://turso.tech";
    mainProgram = "turso";
    license = licenses.mit;
    maintainers = with maintainers; [ zestsystem kashw2 ];
  };
}
