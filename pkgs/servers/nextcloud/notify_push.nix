{ lib
, fetchFromGitHub
, nixosTests
, rustPackages_1_76
}:

rustPackages_1_76.rustPlatform.buildRustPackage rec {
  pname = "notify_push";
  version = "0.6.11";

  src = fetchFromGitHub {
    owner = "nextcloud";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-241p+9gLyEe2Mkc0GQ/Z0BjbxV5OZfbDC6kqfq7ATaE=";
  };

  cargoHash = "sha256-fGbRmrOEbs9nGZhcu1w7qOIwYMaTohaUFb7dilPuTHc=";

  passthru = rec {
    test_client = rustPackages_1_76.rustPlatform.buildRustPackage {
      pname = "${pname}-test_client";
      inherit src version;

      buildAndTestSubdir = "test_client";

      cargoHash = "sha256-RJnNwSDwIA0M+BufBKT9a/pyHwpcpJFR//j0fE4U3gE=";

      meta = meta // {
        mainProgram = "test_client";
      };
    };
    tests = {
      inherit (nixosTests.nextcloud)
        with-postgresql-and-redis27
        with-postgresql-and-redis28
        with-postgresql-and-redis29;
      inherit test_client;
    };
  };

  meta = with lib; {
    changelog = "https://github.com/nextcloud/notify_push/releases/tag/v${version}";
    description = "Update notifications for nextcloud clients";
    homepage = "https://github.com/nextcloud/notify_push";
    license = licenses.agpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ajs124 ];
  };
}
