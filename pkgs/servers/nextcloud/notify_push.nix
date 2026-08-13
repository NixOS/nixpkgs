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
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "nextcloud";
    repo = "notify_push";
    tag = "v${version}";
    hash = "sha256-zIYAVNWJ/lXBAWl1MVxZbQH9ep8aNrAJ6l5ypnSQ5ik=";
  };

  cargoHash = "sha256-0BCM9TT1SRa0Y2EC5bNt2lM8qcgYOvr1sms4yhSzgHU=";

  passthru = rec {
    app = fetchNextcloudApp {
      appName = "notify_push";
      appVersion = version;
      hash = "sha256-nZbIHZSj7KtvCPYVBZXED0+WfmWwuCN4QHa+yfrxzIg=";
      license = "agpl3Plus";
      homepage = "https://github.com/nextcloud/notify_push";
      url = "https://github.com/nextcloud-releases/notify_push/releases/download/v${version}/notify_push-v${version}.tar.gz";
      description = "Push update support for desktop app";
    };

    test_client = rustPlatform.buildRustPackage {
      pname = "${pname}-test_client";
      inherit src version;

      buildAndTestSubdir = "test_client";

      cargoHash = "sha256-0BCM9TT1SRa0Y2EC5bNt2lM8qcgYOvr1sms4yhSzgHU=";

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
    maintainers = with lib.maintainers; [
      das_j
      helsinki-Jo
    ];
  };
}
