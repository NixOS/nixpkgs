{
  lib,
  symlinkJoin,
  makeBinaryWrapper,
  fcitx5,
  withConfigtool ? true,
  fcitx5-configtool,
  libsForQt5,
  qt6Packages,
  fcitx5-gtk,
  addons ? [ ],
}:

symlinkJoin {
  name = "fcitx5-with-addons-${fcitx5.version}";

  paths =
    [
      fcitx5
      libsForQt5.fcitx5-qt
      qt6Packages.fcitx5-qt
      fcitx5-gtk
    ]
    ++ lib.optionals withConfigtool [
      fcitx5-configtool
    ]
    ++ addons;

  nativeBuildInputs = [ makeBinaryWrapper ];

  postBuild = ''
    wrapProgram $out/bin/fcitx5 \
      --prefix FCITX_ADDON_DIRS : "$out/lib/fcitx5" \
      --suffix XDG_DATA_DIRS : "$out/share" \
      --suffix PATH : "$out/bin" \
      --suffix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath (lib.flatten (map (x: x.extraLdLibraries or [ ]) addons))
      }"

    ${lib.optionalString withConfigtool ''
      # Configtool call libexec/fcitx5-qt5-gui-wrapper for gui addons in FCITX_ADDON_DIRS
      wrapProgram $out/bin/fcitx5-config-qt --prefix FCITX_ADDON_DIRS : "$out/lib/fcitx5"
    ''}

    pushd $out
    grep -Rl --include=\*.{desktop,service} share/applications etc/xdg/autostart share/dbus-1/services -e ${fcitx5} | while read -r file; do
      rm $file
      cp ${fcitx5}/$file $file
      substituteInPlace $file --replace-fail ${fcitx5} $out
    done
    popd
  '';

  inherit (fcitx5) meta;
}
