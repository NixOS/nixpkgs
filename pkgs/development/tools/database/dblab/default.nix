{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dblab";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "danvergara";
    repo = "dblab";
    rev = "v${version}";
    hash = "sha256-xaggGX1BROyfexPV3I2TGYf3BPHg2uFebm8XZ0qwXUw=";
  };

  vendorHash = "sha256-RmZkSlA6KU1wXKFHPLYVhRjwxsDjO1XNoGBdNCmeGSw=";

  ldflags = [ "-s -w -X main.version=${version}" ];

  # some tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Database client every command line junkie deserves";
    homepage = "https://github.com/danvergara/dblab";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
