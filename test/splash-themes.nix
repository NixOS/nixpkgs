{fetchurl}:

rec {

  # Some themes.
  
  themeBabyTux = fetchurl {
    url = http://www.bootsplash.de/files/themes/Theme-BabyTux.tar.bz2;
    md5 = "a6d89d1c1cff3b6a08e2f526f2eab4e0";
  };

  themeFrozenBubble = fetchurl {
    url = http://www.bootsplash.de/files/themes/Theme-FrozenBubble.tar.bz2;
    md5 = "da49f04988ab04b7e0de117b0d25061a";
  };

  themePativo = fetchurl { # Yeah!
    url = http://www.bootsplash.de/files/themes/Theme-Pativo.tar.bz2;
    md5 = "9e13beaaadf88d43a5293e7ab757d569";
  };

  themeGNU = fetchurl {
    url = http://www.bootsplash.de/files/themes/Theme-GNU.tar.bz2;
    md5 = "61969309d23c631e57b0a311102ef034";
  };


  # The splash screen.
  
  splashScreen = themeBabyTux;


  # The themes to use for each tty.  For each tty except the first
  # entry in the list, you can omit `theme' to get the same theme as
  # the first one.  If a tty does not appear, it doesn't get a
  # theme (i.e., it will keep a black background).
  
  ttyBackgrounds = [
    { tty = 1;
      theme = themeBabyTux;
    }
    { tty = 2;
    }
    { tty = 3;
      theme = themeGNU;
    }
    { tty = 4;
      theme = themeGNU;
    }
    { tty = 5;
      theme = themePativo;
    }
    { tty = 10; # logging console
      theme = themeGNU;
    }
  ];
  
}
