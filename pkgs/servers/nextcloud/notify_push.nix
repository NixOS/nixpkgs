{ lib
, fetchFromGitHub
, nixosTests
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "notify_push";
  version = "0.6.9";

  src = fetchFromGitHub {
    owner = "nextcloud";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Bwneum3X4Gttb5fFhWyCIchGebxH9Rp0Dg10f0NkKCY=";
  };

  cargoHash = "sha256-HIt56r2sox9LD6kyJxyGFt9mrH/wrC7QkiycLdUDbPo=";

  passthru = rec {
    test_client = rustPlatform.buildRustPackage {
      pname = "${pname}-test_client";
      inherit src version;

      buildAndTestSubdir = "test_client";

      cargoHash = "sha256-OUALNd64rr2qXyRNV/O+pi+dE0HYogwlbWx5DCACzyk=";

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
