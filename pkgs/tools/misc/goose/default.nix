{ lib
, buildGoModule
, fetchFromGitHub
, stdenv
}:

buildGoModule rec {
  pname = "goose";
  version = "3.13.0";

  src = fetchFromGitHub {
    owner = "pressly";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-F8VfyxcacNSrjjBScrEk1QC5CQGifum0ZHgb4gYRmpY=";
  };

  proxyVendor = true;
  vendorHash = "sha256-eE21EU09X6E2EDai3R7l916A3DDVj3bDAvB2VXagv48=";

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
  };
}
