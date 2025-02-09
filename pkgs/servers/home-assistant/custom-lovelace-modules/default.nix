{ callPackage
}:

{
  light-entity-card = callPackage ./light-entity-card { };

  mini-graph-card = callPackage ./mini-graph-card {};

  mini-media-player = callPackage ./mini-media-player {};

  zigbee2mqtt-networkmap = callPackage ./zigbee2mqtt-networkmap { };
}
