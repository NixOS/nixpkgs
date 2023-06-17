{ lib
, buildGoModule
, fetchFromGitHub
, stdenv
}:

buildGoModule rec {
  pname = "goose";
  version = "3.11.2";

  src = fetchFromGitHub {
    owner = "pressly";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-D/mWzDsGNftl0ldNpWt/98b2o5fWk4Jxb5zEIAqTPs0=";
  };

  proxyVendor = true;
  vendorHash = "sha256-6KqYafXtTLmiYrKabuPaszzkN5P3uZDl4LWo1tat/Bk=";

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
