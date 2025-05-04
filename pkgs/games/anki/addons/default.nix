{
  callPackage,
}:
{
  adjust-sound-volume = callPackage ./adjust-sound-volume { };

  anki-connect = callPackage ./anki-connect { };

  passfail2 = callPackage ./passfail2 { };
}
