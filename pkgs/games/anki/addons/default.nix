{
  callPackage,
}:
{
  adjust-sound-volume = callPackage ./adjust-sound-volume { };

  anki-connect = callPackage ./anki-connect { };

  passfail2 = callPackage ./passfail2 { };

  reviewer-refocus-card = callPackage ./reviewer-refocus-card { };

  yomichan-forvo-server = callPackage ./yomichan-forvo-server { };
}
