{ lib
, fetchFromGitHub
, nixosTests
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "notify_push";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "nextcloud";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-go41ZIUBj1nj8rDI/c4Pk5cnDbM8Y2+bCZIab4XdhUY=";
  };

  cargoHash = "sha256-EuYwPQo2TucAaQw63pESkJGAtyuMhk3JT6mBg6E84Xs=";

  passthru = rec {
    test_client = rustPlatform.buildRustPackage {
      pname = "${pname}-test_client";
      inherit src version;

      buildAndTestSubdir = "test_client";

      cargoHash = "sha256-m4FHCrVGAmGIrgnMMleiTRgYGYh+b7EIH1ORE0tiBkY=";
    };
    tests = {
      inherit (nixosTests.nextcloud) with-postgresql-and-redis26;
      inherit test_client;
    };
  };

  meta = with lib; {
    description = "Update notifications for nextcloud clients";
    homepage = "https://github.com/nextcloud/notify_push";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ ajs124 ];
  };
}
