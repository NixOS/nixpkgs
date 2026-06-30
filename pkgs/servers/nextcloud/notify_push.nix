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
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "nextcloud";
    repo = "notify_push";
    tag = "v${version}";
    hash = "sha256-DMyqixeO1SfRvfuIpBHEaym6qH5X5Yw94tfWLCFkrBg=";
  };

  cargoHash = "sha256-fdf7AvT511WRjsOyM4+3vieuQMh24C+mF49pWtfS41Y=";

  passthru = rec {
    app = fetchNextcloudApp {
      appName = "notify_push";
      appVersion = version;
      hash = "sha256-gHRegrl1VtJOiB6xLUHtG3sxkCDv7/zhrhQ9B+9i8YI=";
      license = "agpl3Plus";
      homepage = "https://github.com/nextcloud/notify_push";
      url = "https://github.com/nextcloud-releases/notify_push/releases/download/v${version}/notify_push-v${version}.tar.gz";
      description = "Push update support for desktop app";
    };

    test_client = rustPlatform.buildRustPackage {
      pname = "${pname}-test_client";
      inherit src version;

      buildAndTestSubdir = "test_client";

      cargoHash = "sha256-fdf7AvT511WRjsOyM4+3vieuQMh24C+mF49pWtfS41Y=";

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
