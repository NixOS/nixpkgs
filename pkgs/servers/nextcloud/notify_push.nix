{
  lib,
  fetchFromGitHub,
  nixosTests,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "notify_push";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "nextcloud";
    repo = "notify_push";
    tag = "v${version}";
    hash = "sha256-Y71o+ARi/YB2BRDfEyORbrA9HPvsUlWdh5UjM8hzmcA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-bO3KN+ynxNdbnFv1ZHJSSPWd4SxWQGIis3O3Gfba8jw=";

  passthru = rec {
    test_client = rustPlatform.buildRustPackage {
      pname = "${pname}-test_client";
      inherit src version;

      buildAndTestSubdir = "test_client";

      cargoHash = "sha256-SBEuFOTgqNjPtKx0PFDA5Gkiksn3cZEmYcs2shAo2Po=";

      meta = meta // {
        mainProgram = "test_client";
      };
    };
    tests =
      lib.filterAttrs (
        key: lib.const (lib.hasPrefix "with-postgresql-and-redis" key)
      ) nixosTests.nextcloud
      // {
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
