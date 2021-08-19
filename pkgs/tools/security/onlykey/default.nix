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
  # this must be updated anytime this package is updated.
  onlykeyPkg = "onlykey-git://github.com/trustcrypto/OnlyKey-App.git#v5.3.3";

  # define a shortcut to get to onlykey.
  onlykey = self."${onlykeyPkg}";

  super = (import ./onlykey.nix {
    inherit pkgs;
    inherit (stdenv.hostPlatform) system;
  });

  # extract the nw dependency out of the computed
  nwDependency = builtins.head (builtins.filter (d: d.packageName == "nw") onlykey.dependencies);

  # In order to satisfy nw's installation of nwjs, create a directory that
  # includes the tarball or zipfile and place it at a location the installation
  # script will look for it.
  #
  #   Reference:
  #   https://github.com/nwjs/npm-installer/blob/4e65f25c5c1f119ab2c79aefea1020db7be38bc7/scripts/install.js#L37-L52
  #
  nwjsBase =
    let
      name =
        if stdenv.isLinux then "nwjs-v${nwDependency.version}-linux-x64"
        else if stdenv.isDarwin then "nwjs-v${nwDependency.version}-osx-x64"
        else throw "platform not supported";

      command =
        if stdenv.isLinux then "${pkgs.gnutar}/bin/tar --dereference -czf $out/${nwDependency.version}/${name}.tar.gz ${name}"
        else if stdenv.isDarwin then ""
        else throw "platform not supported";
    in
    runCommand "nwjs-base" { } ''
      mkdir -p $out/${nwDependency.version}
      ln -s ${pkgs.nwjs}/share/nwjs ${name}
      ${command}
    '';

  self = super // {
    "${onlykeyPkg}" = super."${onlykeyPkg}".override (attrs: {
      # See explanation above regarding the nwjsBase.
      NWJS_URLBASE = "file://${nwjsBase}/";

      # this is needed to allow us to parse the version of the nw dependency
      passthru = { inherit (attrs) dependencies; };

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
