{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dbmate";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "amacneil";
    repo = "dbmate";
    rev = "refs/tags/v${version}";
    hash = "sha256-gJ1kYedws20C669Gonmsui59a/TvPXawqkx5k4pPn8M=";
  };

  vendorHash = "sha256-JjFBUjSbHnJE7FPa11lQBx7Dvv7uBkuvLYqeuaDkHJM=";

  doCheck = false;

  meta = with lib; {
    description = "Database migration tool";
    homepage = "https://github.com/amacneil/dbmate";
    changelog = "https://github.com/amacneil/dbmate/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ manveru ];
  };
}
