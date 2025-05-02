{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dblab";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "danvergara";
    repo = "dblab";
    rev = "v${version}";
    hash = "sha256-eIkHaNFvXU9GGyYOH8lqzvwQQ6pz8zWeO4xY9jP25dU=";
  };

  vendorHash = "sha256-WzyH3Ja/Znk/9aavIoBQRpJVnGb5o/ded0g92MTa4M4=";

  ldflags = [ "-s -w -X main.version=${version}" ];

  # some tests require network access
  doCheck = false;

  meta = with lib; {
    description = "The database client every command line junkie deserves";
    homepage = "https://github.com/danvergara/dblab";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
