{
  lib,
  linuxPackages,
  runCommand,
}:

let
  inherit (linuxPackages.nvidiaPackages) mkDriver production;
  version = production.version;
  settingsVersion = "${version}-settings-test";
  persistencedVersion = "${version}-persistenced-test";

  # Only evaluate metadata: these synthetic component revisions and hashes must
  # never be fetched or built. Use the real mkDriver, not a mock of its behavior.
  driverArgs = {
    inherit version;
    sha256_64bit = lib.fakeHash;
    sha256_aarch64 = lib.fakeHash;
    openSha256 = lib.fakeHash;
    settingsSha256 = lib.fakeHash;
    persistencedSha256 = lib.fakeHash;
  };

  cases = {
    Defaults = {
      overrides = { };
      settings = version;
      persistenced = version;
    };
    ExplicitNull = {
      overrides = {
        settingsVersion = null;
        persistencedVersion = null;
      };
      settings = version;
      persistenced = version;
    };
    SettingsOverride = {
      overrides = { inherit settingsVersion; };
      settings = settingsVersion;
      persistenced = version;
    };
    PersistencedOverride = {
      overrides = { inherit persistencedVersion; };
      settings = version;
      persistenced = persistencedVersion;
    };
    BothOverrides = {
      overrides = { inherit settingsVersion persistencedVersion; };
      settings = settingsVersion;
      persistenced = persistencedVersion;
    };
  };

  # Mirrors may change host or order, but every URL must retain the component
  # and exact revision. An empty mirror list must not pass vacuously.
  sourceUsesRevision =
    component: revision: source:
    source.urls != [ ]
    && lib.all (
      url:
      lib.hasSuffix "/${component}/archive/${revision}.tar.gz" url
      || lib.hasSuffix "/${component}/archive/refs/tags/${revision}.tar.gz" url
      || lib.hasSuffix "/${component}/${component}-${revision}.tar.bz2" url
    ) source.urls;

  failures = lib.runTests (
    lib.mapAttrs' (
      name: case:
      let
        driver = mkDriver (driverArgs // case.overrides);
      in
      lib.nameValuePair "test${name}" {
        expr = {
          settings = driver.settings.version;
          persistenced = driver.persistenced.version;
          libXNVCtrl = driver.settings.libXNVCtrl.version;
          libXNVCtrlSources =
            sourceUsesRevision "nvidia-settings" case.settings
              driver.settings.libXNVCtrl.src;
          settingsSources = sourceUsesRevision "nvidia-settings" case.settings driver.settings.src;
          persistencedSources =
            sourceUsesRevision "nvidia-persistenced" case.persistenced
              driver.persistenced.src;
        };
        expected = {
          inherit (case) settings persistenced;
          libXNVCtrl = case.settings;
          libXNVCtrlSources = true;
          settingsSources = true;
          persistencedSources = true;
        };
      }
    ) cases
  );
in

# This free, hardware-independent test is discoverable by the release jobset.
# Invoke directly with: nix-build -A tests.nvidia-component-versions
runCommand "nvidia-component-versions"
  {
    meta.platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  }
  (
    assert
      lib.debug.throwTestFailures {
        inherit failures;
        description = "NVIDIA component version propagation";
      } == null;
    "touch $out"
  )
