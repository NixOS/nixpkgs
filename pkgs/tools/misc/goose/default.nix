{ lib
, buildGoModule
, fetchFromGitHub
, stdenv
}:

buildGoModule rec {
  pname = "goose";
  version = "3.22.1";

  src = fetchFromGitHub {
    owner = "pressly";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-rXh50Yv8UXJc+E32Fgg6Iy2K6x5+IM7dmxsvwFuCQ9U=";
  };

  proxyVendor = true;
  vendorHash = "sha256-xb3yBiV+XyOlMp42c+eCj27DpvJalP5qhEoKG1X2kG8=";

  # skipping: end-to-end tests require a docker daemon
  postPatch = ''
    rm -r tests/gomigrations
  '';

  subPackages = [
    "cmd/goose"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  checkFlags = [
    # NOTE:
    # - skipping: these also require a docker daemon
    # - these are for go tests that live outside of the /tests directory
    "-skip=TestClickUpDown|TestClickHouseFirstThree|TestLockModeAdvisorySession|TestDialectStore|TestGoMigrationStats|TestPostgresSessionLocker"
  ];

  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "Database migration tool which supports SQL migrations and Go functions";
    homepage = "https://pressly.github.io/goose/";
    license = licenses.bsd3;
    maintainers = [ ];
    mainProgram = "goose";
  };
}
