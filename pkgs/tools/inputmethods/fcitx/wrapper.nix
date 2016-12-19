{ stdenv, symlinkJoin, fcitx, fcitx-configtool, makeWrapper, plugins, qt55 }:

symlinkJoin {
  name = "fcitx-with-plugins-${fcitx.version}";

  paths = [ fcitx fcitx-configtool qt55.fcitx-qt5 ] ++ plugins;

  buildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/fcitx \
      --set FCITXDIR "$out/"
  '';
}
