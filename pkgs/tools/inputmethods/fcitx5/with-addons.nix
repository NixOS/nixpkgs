<<<<<<< HEAD
{ lib
, symlinkJoin
, makeBinaryWrapper
, fcitx5
, withConfigtool ? true
, fcitx5-configtool
, fcitx5-qt
, fcitx5-gtk
, addons ? [ ]
}:
=======
{ lib, symlinkJoin, makeWrapper, fcitx5, fcitx5-configtool, fcitx5-qt, fcitx5-gtk, addons ? [ ] }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

symlinkJoin {
  name = "fcitx5-with-addons-${fcitx5.version}";

<<<<<<< HEAD
  paths = [
    fcitx5
    fcitx5-qt
    fcitx5-gtk
  ] ++ lib.optionals withConfigtool [
    fcitx5-configtool
  ] ++ addons;

  nativeBuildInputs = [ makeBinaryWrapper ];
=======
  paths = [ fcitx5 fcitx5-configtool fcitx5-qt fcitx5-gtk ] ++ addons;

  nativeBuildInputs = [ makeWrapper ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postBuild = ''
    wrapProgram $out/bin/fcitx5 \
      --prefix FCITX_ADDON_DIRS : "$out/lib/fcitx5" \
      --suffix XDG_DATA_DIRS : "$out/share" \
      --suffix PATH : "$out/bin" \
<<<<<<< HEAD
      --suffix LD_LIBRARY_PATH : "${lib.makeLibraryPath (lib.flatten (map (x: x.extraLdLibraries or []) addons))}"

    ${lib.optionals withConfigtool ''
      # Configtool call libexec/fcitx5-qt5-gui-wrapper for gui addons in FCITX_ADDON_DIRS
      wrapProgram $out/bin/fcitx5-config-qt --prefix FCITX_ADDON_DIRS : "$out/lib/fcitx5"
    ''}
=======
      --suffix LD_LIBRARY_PATH : ${lib.makeLibraryPath (lib.flatten (map (x: x.extraLdLibraries or []) addons))}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
