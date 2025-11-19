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
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "nextcloud";
    repo = "notify_push";
    tag = "v${version}";
    hash = "sha256-yEls1s7tD/fcqul/BmEsRf2g5mqD74M8TKG+Na3jlcM=";
  };

  cargoHash = "sha256-+z9XaAzToLZg6/PoRigkvPVpZ/bX/t0VBR5bg3dCUVw=";

  passthru = rec {
    app = fetchNextcloudApp {
      appName = "notify_push";
      appVersion = version;
      hash = "sha256-Yad1+kc0uCHRV4q7IDbQT8Ea2423YWGy9k42DHB0R1Q=";
      license = "agpl3Plus";
      homepage = "https://github.com/nextcloud/notify_push";
      url = "https://github.com/nextcloud-releases/notify_push/releases/download/v${version}/notify_push-v${version}.tar.gz";
      description = "Push update support for desktop app";
    };

    test_client = rustPlatform.buildRustPackage {
      pname = "${pname}-test_client";
      inherit src version;

      buildAndTestSubdir = "test_client";

      cargoHash = "sha256-+z9XaAzToLZg6/PoRigkvPVpZ/bX/t0VBR5bg3dCUVw=";

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
    teams = [ teams.helsinki-systems ];
  };
}
