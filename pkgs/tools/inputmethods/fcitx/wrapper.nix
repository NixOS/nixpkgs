{ stdenv, symlinkJoin, fcitx, fcitx-configtool, makeWrapper, plugins, libsForQt5 }:

symlinkJoin {
  name = "fcitx-with-plugins-${fcitx.version}";

  paths = [ fcitx fcitx-configtool libsForQt5.fcitx-qt5 ] ++ plugins;

  buildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/fcitx \
      --set FCITXDIR "$out/"
  '';
}
