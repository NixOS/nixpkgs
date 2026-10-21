{
  lib,
  fetchFromGitHub,
  nixosTests,
  rustPlatform,
  fetchNextcloudApp,
}:

rustPlatform.buildRustPackage rec {
  pname = "notify_push";

  # NOTE: make sure this is compatible with all Nextcloud versions
  # in nixpkgs!
  # For that, check the `<dependencies>` section of `appinfo/info.xml`
  # in the app (https://github.com/nextcloud/notify_push/blob/main/appinfo/info.xml)
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "nextcloud";
    repo = "notify_push";
    tag = "v${version}";
    hash = "sha256-xkPcE01gtzbE95XimBWjvV500+rnAeb5we+iRce00o8=";
  };

  cargoHash = "sha256-2tJ1rIw+NoVo9sh8qOtPszD55Gg8vjuX0jI2z9bunxo=";

  passthru = rec {
    app = fetchNextcloudApp {
      appName = "notify_push";
      appVersion = version;
      hash = "sha256-C/2jXLpuIbxjWO3kMb3nkLA5762uVLuzk1YPz/YSfjY=";
      license = "agpl3Plus";
      homepage = "https://github.com/nextcloud/notify_push";
      url = "https://github.com/nextcloud-releases/notify_push/releases/download/v${version}/notify_push-v${version}.tar.gz";
      description = "Push update support for desktop app";
    };

    test_client = rustPlatform.buildRustPackage {
      pname = "${pname}-test_client";
      inherit src version;

      buildAndTestSubdir = "test_client";

      cargoHash = "sha256-2tJ1rIw+NoVo9sh8qOtPszD55Gg8vjuX0jI2z9bunxo=";

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

  meta = {
    changelog = "https://github.com/nextcloud/notify_push/releases/tag/v${version}";
    description = "Update notifications for nextcloud clients";
    mainProgram = "notify_push";
    homepage = "https://github.com/nextcloud/notify_push";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ helsinki-Jo ];
  };
}
