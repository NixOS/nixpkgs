{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dbmate";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "amacneil";
    repo = "dbmate";
    rev = "refs/tags/v${version}";
    hash = "sha256-5dYWCcCQymwzWGY67lds5QQzHHkKt3OGkvqXDLwt/q8=";
  };

  vendorHash = "sha256-1sfIwawsWefh+nj4auqRjU4dWuDbgpvhAc8cF8DhICg=";

  doCheck = false;

  meta = with lib; {
    description = "Database migration tool";
    homepage = "https://github.com/amacneil/dbmate";
    changelog = "https://github.com/amacneil/dbmate/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ manveru ];
  };
}
