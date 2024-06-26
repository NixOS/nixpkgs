{ lib
, fetchFromGitHub
, nixosTests
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "notify_push";
  version = "0.6.12";

  src = fetchFromGitHub {
    owner = "nextcloud";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Wbrkr9DWOQpOKAp9X/PzU8alDDrDapX/1hE+ObbD/nc=";
  };

  cargoHash = "sha256-4bgbhtqdb1IVsf0yIcZOXZCVdRHjdvhZe/VCab0kuMk=";

  passthru = rec {
    test_client = rustPlatform.buildRustPackage {
      pname = "${pname}-test_client";
      inherit src version;

      buildAndTestSubdir = "test_client";

      cargoHash = "sha256-Z7AX/PXfiUHEV/M+i/2qne70tcZnnPj/iNT+DNMECS8=";

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
    mainProgram = "notify_push";
    homepage = "https://github.com/nextcloud/notify_push";
    license = licenses.agpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.helsinki-systems.members;
  };
}
