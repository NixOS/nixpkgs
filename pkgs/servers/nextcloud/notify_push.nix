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
    app = fetchNextcloudApp {
      appName = "notify_push";
      appVersion = version;
      hash = "sha256-4yCs4Q25PhYVICAIFlNiRTOFvL0JdmUwR5bNxp54GiA=";
      license = "agpl3Plus";
      homepage = "https://github.com/nextcloud/notify_push";
      url = "https://github.com/nextcloud-releases/notify_push/releases/download/v${version}/notify_push-v${version}.tar.gz";
      description = "Push update support for desktop app";
    };

    test_client = rustPlatform.buildRustPackage {
      pname = "${pname}-test_client";
      inherit src version;

      buildAndTestSubdir = "test_client";

      useFetchCargoVendor = true;
      cargoHash = "sha256-bO3KN+ynxNdbnFv1ZHJSSPWd4SxWQGIis3O3Gfba8jw=";

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
