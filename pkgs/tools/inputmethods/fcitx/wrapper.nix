{ stdenv, symlinkJoin, fcitx, fcitx-configtool, makeWrapper, plugins, kde5 }:

symlinkJoin {
  name = "fcitx-with-plugins-${fcitx.version}";

  paths = [ fcitx fcitx-configtool kde5.fcitx-qt5 ] ++ plugins;

  buildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/fcitx \
      --set FCITXDIR "$out/"
  '';
}
