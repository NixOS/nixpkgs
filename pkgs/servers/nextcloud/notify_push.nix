{ lib
, fetchFromGitHub
, nixosTests
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "notify_push";
  version = "0.6.10";

  src = fetchFromGitHub {
    owner = "nextcloud";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Kk9l9jowerxh5nsKQ5TOaijSJbs0DgJKaRl9tlAttzI=";
  };

  cargoHash = "sha256-wtmYWQOYy8JmbSxgrXkFtDe6KmJJIMVpcELQj06II4k=";

  passthru = rec {
    test_client = rustPlatform.buildRustPackage {
      pname = "${pname}-test_client";
      inherit src version;

      buildAndTestSubdir = "test_client";

      cargoHash = "sha256-sPUlke8KI6sX2HneeoZh8RMG7aydC43c37V179ipukU=";

      meta = meta // {
        mainProgram = "test_client";
      };
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
    mainProgram = "notify_push";
    homepage = "https://github.com/nextcloud/notify_push";
    license = licenses.agpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.helsinki-systems.members;
  };
}
