{ lib
, buildGoModule
, fetchFromGitHub
, stdenv
}:

buildGoModule rec {
  pname = "goose";
  version = "3.13.4";

  src = fetchFromGitHub {
    owner = "pressly";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-mz7kB8ygDm23bsuQy9mYnWSGF6DDGqBtvj82s2PLDR0=";
  };

  proxyVendor = true;
  vendorHash = "sha256-lWlv6+Auj9YGxyJXr5WGbe4AWqJSpHE9RTY+9ZXyPVQ=";

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
