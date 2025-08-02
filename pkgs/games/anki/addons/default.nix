{
  callPackage,
}:
{
  adjust-sound-volume = callPackage ./adjust-sound-volume { };

  anki-button-colours = callPackage ./anki-button-colours { };

  anki-connect = callPackage ./anki-connect { };

  local-audio-yomichan = callPackage ./local-audio-yomichan { };

  passfail2 = callPackage ./passfail2 { };

  recolor = callPackage ./recolor { };

  reviewer-refocus-card = callPackage ./reviewer-refocus-card { };

  yomichan-forvo-server = callPackage ./yomichan-forvo-server { };
}
