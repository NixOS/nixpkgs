{ fetchgit
, lib
, makeDesktopItem
, node_webkit
, pkgs
, runCommand
, stdenv
, writeShellScript
}:

let
  # parse the version from package.json
  version =
    let
      packageJson = lib.importJSON ./package.json;
      splits = builtins.split "^.*#v(.*)$" (builtins.getAttr "onlykey" (builtins.head packageJson));
      matches = builtins.elemAt splits 1;
      elem = builtins.head matches;
    in
    elem;

  # this must be updated anytime this package is updated.
  onlykeyPkg = "onlykey-git+https://github.com/trustcrypto/OnlyKey-App.git#v${version}";

  # define a shortcut to get to onlykey.
  onlykey = self."${onlykeyPkg}";

  super = (import ./onlykey.nix {
    inherit pkgs;
    inherit (stdenv.hostPlatform) system;
  });

  self = super // {
    "${onlykeyPkg}" = super."${onlykeyPkg}".override (attrs: {
      # when installing packages, nw tries to download nwjs in its postInstall
      # script. There are currently no other postInstall scripts, so this
      # should not break other things.
      npmFlags = attrs.npmFlags or "" + " --ignore-scripts";

      # this package requires to be built in order to become runnable.
      postInstall = ''
        cd $out/lib/node_modules/${attrs.packageName}
        npm run build
      '';
    });
  };

  script = writeShellScript "${onlykey.packageName}-starter-${onlykey.version}" ''
    ${node_webkit}/bin/nw ${onlykey}/lib/node_modules/${onlykey.packageName}/build
  '';

  desktop = makeDesktopItem {
    name = onlykey.packageName;
    exec = script;
    icon = "${onlykey}/lib/node_modules/${onlykey.packageName}/resources/onlykey_logo_128.png";
    desktopName = onlykey.packageName;
    genericName = onlykey.packageName;
  };
in
runCommand "${onlykey.packageName}-${onlykey.version}" { } ''
  mkdir -p $out/bin
  ln -s ${script} $out/bin/onlykey
''
