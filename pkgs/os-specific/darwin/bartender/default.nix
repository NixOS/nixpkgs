{ lib
, fetchurl
, darwin
}:

darwin.installBinaryPackage rec {
  pname = "bartender";
  version = "5.0.49";

  src = fetchurl {
    url = "https://www.macbartender.com/B2/updates/${builtins.replaceStrings [ "." ] [ "-" ] version}/Bartender%20${lib.versions.major version}.dmg";
    hash = "sha256-DOQLtdbwYFyRri3GBdjLfFNII65QJMvAQu9Be4ATBx0=";
  };

  appName = "Bartender ${lib.versions.major version}.app";

  meta = with lib; {
    description = "Take control of your menu bar";
    longDescription = ''
      Bartender is an award-winning app for macOS that superpowers your menu
      bar, giving you total control over your menu bar items, what's displayed,
      and when, with menu bar items only showing when you need them.
      Bartender improves your workflow with quick reveal, search, custom
      hotkeys and triggers, and lots more.
    '';
    homepage = "https://www.macbartender.com";
    changelog = "https://www.macbartender.com/Bartender${lib.versions.major version}/release_notes/";
    license = with licenses; [ unfree ];
    maintainers = with maintainers; [ stepbrobd ];
  };
}
