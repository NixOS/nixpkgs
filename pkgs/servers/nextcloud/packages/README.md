= Adding apps =

To extend the nextcloudPackages set, add a new line to the corresponding json
file with the id of the app:

- `nextcloud-apps.json` for apps

The app must be available in the official
[Nextcloud app store](https://apps.nextcloud.com).
https://apps.nextcloud.com. The id corresponds to the last part in the app url,
for example `breezedark` for the app with the url
`https://apps.nextcloud.com/apps/breezedark`.

To regenerate the nixpkgs nextcloudPackages set, run:

```
./generate.sh
```

After that you can commit and submit the changes.

= Usage with the Nextcloud module =

The apps will be available in the namespace `nextcloud25Packages.apps`.
Using it together with the Nextcloud module could look like this:

```
services.nextcloud = {
  enable = true;
  package = pkgs.nextcloud25;
  hostName = "localhost";
  config.adminpassFile = "${pkgs.writeText "adminpass" "hunter2"}";
  extraApps = with pkgs.nextcloud25Packages.apps; [
    mail
    calendar
    contacts
  ];
  extraAppsEnable = true;
};
```

Adapt the version number in the Nextcloud package and nextcloudPackages set
according to the Nextcloud version you wish to use. There are several supported
stable Nextcloud versions available in the repository.
