{
  mkTmuxPlugin,
  thumbs,
  replaceVars,
}:

mkTmuxPlugin {

  inherit (thumbs) version src meta;

  pluginName = thumbs.src.repo;
  rtpFilePath = "tmux-thumbs.tmux";

  patches = [
    (replaceVars ./fix.patch {
      tmuxThumbsDir = "${thumbs}/bin";
    })
  ];

}
