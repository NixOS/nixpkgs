{
  lib,
  pkgs,
  callPackage,
}:

{
  apexcharts-card = callPackage ./apexcharts-card { };

  atomic-calendar-revive = callPackage ./atomic-calendar-revive { };

  button-card = callPackage ./button-card { };

  card-mod = callPackage ./card-mod { };

  decluttering-card = callPackage ./decluttering-card { };

  hourly-weather = callPackage ./hourly-weather { };

  lg-webos-remote-control = callPackage ./lg-webos-remote-control { };

  light-entity-card = callPackage ./light-entity-card { };

  mini-graph-card = callPackage ./mini-graph-card {};

  mini-media-player = callPackage ./mini-media-player {};

  multiple-entity-row = callPackage ./multiple-entity-row { };

  mushroom = callPackage ./mushroom { };

  rmv-card = callPackage ./rmv-card { };

  template-entity-row = callPackage ./template-entity-row { };

  universal-remote-card = callPackage ./universal-remote-card { };

  valetudo-map-card = callPackage ./valetudo-map-card { };

  zigbee2mqtt-networkmap = callPackage ./zigbee2mqtt-networkmap { };
}
// lib.optionalAttrs pkgs.config.allowAliases {
  android-tv-card =
    lib.warn "`home-assistant-custom-lovelace-modules.android-tv-card` has been renamed to `universal-remote-card`"
    pkgs.home-assistant-custom-lovelace-modules.universal-remote-card;
}
