{ lib, symlinkJoin, makeWrapper, fcitx5, fcitx5-configtool, fcitx5-qt, fcitx5-gtk, addons ? [ ] }:

symlinkJoin {
  name = "fcitx5-with-addons-${fcitx5.version}";

  paths = [ fcitx5 fcitx5-configtool fcitx5-qt fcitx5-gtk ] ++ addons;

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/fcitx5 \
      --prefix FCITX_ADDON_DIRS : "$out/lib/fcitx5" \
      --suffix XDG_DATA_DIRS : "$out/share" \
      --suffix PATH : "$out/bin" \
      --suffix LD_LIBRARY_PATH : ${lib.makeLibraryPath (lib.flatten (map (x: x.extraLdLibraries or []) addons))}

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
