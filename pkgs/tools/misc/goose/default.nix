{ lib
, buildGoModule
, fetchFromGitHub
, stdenv
}:

buildGoModule rec {
  pname = "goose";
  version = "3.15.0";

  src = fetchFromGitHub {
    owner = "pressly";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-BpCyBd5ogwpZussfKTCnCAcAnvT6jmlvLj2892+bZsg=";
  };

  proxyVendor = true;
  vendorHash = "sha256-hOTP9fR0kK4aPJ0xlgwjl/D7O5rUfy9Xb1ruLV/uk1U=";

  # end-to-end tests require a docker daemon
  postPatch = ''
    rm -r tests/e2e
    rm -r tests/gomigrations
    rm -r tests/vertica
  '';

  ldflags = [
    "-s"
    "-w"
    "-X=main.gooseVersion=${version}"
  ];

  checkFlags = [
    # these also require a docker daemon
    "-skip=TestClickUpDown|TestClickHouseFirstThree"
  ];

  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "Database migration tool which supports SQL migrations and Go functions";
    homepage = "https://pressly.github.io/goose/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ yuka ];
    mainProgram = "goose";
  };
}
