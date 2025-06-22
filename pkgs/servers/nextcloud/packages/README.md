## Updating apps

To regenerate the nixpkgs nextcloudPackages set, run:

```
./generate.sh
```

After that you can commit and submit the changes in a pull request.

## Overriding app licenses

The `appinfo/info.xml` file in each app specifies a license, however in the past it used ambiguous identifiers, which do not map to exactly one SPDX identifier each.
For example `agpl` could mean either `AGPL-3.0-only` or `AGPL-3.0-or-later`, but there is no reliable way to determine it automatically, so the `-only` variant is chosen as a safe fallback which is also compatible with the `-or-later` variant.
Since Nextcloud 31 app maintainers can use SPDX identifiers, which is strongly preferred.

If you are not happy with this fallback approach for a specific app, please open an issue/pull request in the source repository to clarify the license and switch to an SPDX identifier.
If that doesn't work for an app (e.g. unresponsive maintainers), you can override the license in `nextcloud-app-license-overrides.json`, but the license has to be clarified nonetheless.

**Make sure that in this update, only the app added to `nextcloud-apps.json` gets updated.**

After that you can commit and submit the changes in a pull request.

## Usage with the Nextcloud module

The apps will be available in the namespace `nextcloud31Packages.apps` (and for older versions of Nextcloud similarly).
Using it together with the Nextcloud module could look like this:

```
{
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud31;
    hostName = "localhost";
    config.adminpassFile = "${pkgs.writeText "adminpass" "hunter2"}";
    extraApps = with pkgs.nextcloud31Packages.apps; {
      inherit mail calendar contact;
    };
    extraAppsEnable = true;
  };
}
```

Adapt the version number in the Nextcloud package and nextcloudPackages set
according to the Nextcloud version you wish to use. There are several supported
stable Nextcloud versions available in the repository.
