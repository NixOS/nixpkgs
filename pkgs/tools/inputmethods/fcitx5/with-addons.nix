{ symlinkJoin, makeWrapper, fcitx5, fcitx5-lua, fcitx5-configtool, fcitx5-qt, fcitx5-gtk, addons ? [] }:

symlinkJoin {
  name = "fcitx5-with-addons-${fcitx5.version}";

  paths = [ fcitx5 fcitx5-configtool fcitx5-lua fcitx5-qt fcitx5-gtk ] ++ addons;

  buildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/fcitx5 \
      --prefix FCITX_ADDON_DIRS : "$out/lib/fcitx5" \
      --suffix XDG_DATA_DIRS : "$out/share" \
      --suffix PATH : "$out/bin"
  '';

  meta = fcitx5.meta;
}
