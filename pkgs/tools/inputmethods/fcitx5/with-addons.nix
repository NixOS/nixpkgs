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

    desktop=share/applications/org.fcitx.Fcitx5.desktop
    autostart=etc/xdg/autostart/org.fcitx.Fcitx5.desktop
    rm $out/$desktop
    rm $out/$autostart
    cp ${fcitx5}/$desktop $out/$desktop
    sed -i $out/$desktop -e "s|^Exec=.*|Exec=$out/bin/fcitx5|g"
    ln -s $out/$desktop $out/$autostart
  '';

  inherit (fcitx5) meta;
}
