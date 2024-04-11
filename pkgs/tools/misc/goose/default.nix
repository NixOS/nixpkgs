{ lib
, buildGoModule
, fetchFromGitHub
, stdenv
}:

buildGoModule rec {
  pname = "goose";
  version = "3.19.2";

  src = fetchFromGitHub {
    owner = "pressly";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-kGa3vZSFQ8Dgndc0qRnFnQwlU2hst6j3UFUXw+tfYR0=";
  };

  proxyVendor = true;
  vendorHash = "sha256-aoBxReKRk7dkFR/fJ5uHDZrJRGutLTU2BhDWCTBN2BA=";

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
