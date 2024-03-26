{ callPackage
}:

{
  adaptive_lighting = callPackage ./adaptive_lighting {};

  auth-header = callPackage ./auth-header {};

  better_thermostat = callPackage ./better_thermostat {};

  emporia_vue = callPackage ./emporia_vue {};

  epex_spot = callPackage ./epex_spot {};

  frigate = callPackage ./frigate {};

  govee-lan = callPackage ./govee-lan {};

  gpio = callPackage ./gpio {};

  homematicip_local = callPackage ./homematicip_local { };

  localtuya = callPackage ./localtuya {};

  miele = callPackage ./miele {};

  moonraker = callPackage ./moonraker {};

  omnik_inverter = callPackage ./omnik_inverter {};

  prometheus_sensor = callPackage ./prometheus_sensor {};

  sensi = callPackage ./sensi {};

  waste_collection_schedule = callPackage ./waste_collection_schedule {};
}
