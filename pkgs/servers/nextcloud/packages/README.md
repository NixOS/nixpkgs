## Updating apps

To regenerate the nixpkgs nextcloudPackages set, run:

```
./generate.sh
```

After that you can commit and submit the changes in a pull request.

## Adding apps

**Before adding an app and making a pull request to nixpkgs, please first update as described above in a separate commit.**

To extend the nextcloudPackages set, add a new line to the corresponding json
file with the id of the app:

- `nextcloud-apps.json` for apps

The app must be available in the official
[Nextcloud app store](https://apps.nextcloud.com).
https://apps.nextcloud.com. The id corresponds to the last part in the app url,
for example `breezedark` for the app with the url
`https://apps.nextcloud.com/apps/breezedark`.

Then regenerate the nixpkgs nextcloudPackages set by running:

```
./generate.sh
```

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
