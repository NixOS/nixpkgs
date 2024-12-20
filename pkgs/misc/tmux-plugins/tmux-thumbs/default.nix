{
  mkTmuxPlugin,
  thumbs,
  substituteAll,
}:

mkTmuxPlugin {

  inherit (thumbs) version src meta;

  pluginName = thumbs.src.repo;
  rtpFilePath = "tmux-thumbs.tmux";

  patches = [
    (substituteAll {
      src = ./fix.patch;
      tmuxThumbsDir = "${thumbs}/bin";
    })
  ];

}
