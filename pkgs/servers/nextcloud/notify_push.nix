{ lib
, fetchFromGitHub
, nixosTests
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "notify_push";
  version = "0.6.7";

  src = fetchFromGitHub {
    owner = "nextcloud";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-kcdrKrad5kHYOg/1+L72c9Y3GwFA4wS2C9xQ0JOqcOQ=";
  };

  cargoHash = "sha256-jMSPBoLVUe4I+CI8nKOjgTxUUarUa4/KLl+LmehKOzg=";

  passthru = rec {
    test_client = rustPlatform.buildRustPackage {
      pname = "${pname}-test_client";
      inherit src version;

      buildAndTestSubdir = "test_client";

      cargoHash = "sha256-0Vs05DToSeKWQJlTwtETedJV2GQ3LYJYIsxM/xZ6dt4=";
    };
    tests = {
      inherit (nixosTests.nextcloud)
        with-postgresql-and-redis26
        with-postgresql-and-redis27
        with-postgresql-and-redis28;
      inherit test_client;
    };
  };

  meta = with lib; {
    changelog = "https://github.com/nextcloud/notify_push/releases/tag/v${version}";
    description = "Update notifications for nextcloud clients";
    homepage = "https://github.com/nextcloud/notify_push";
    license = licenses.agpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.helsinki-systems.members;
  };
}
