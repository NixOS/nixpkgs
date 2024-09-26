{ callPackage
}:

{
  adaptive_lighting = callPackage ./adaptive_lighting {};

  alarmo = callPackage ./alarmo {};

  auth-header = callPackage ./auth-header {};

  awtrix = callPackage ./awtrix {};

  average = callPackage ./average {};

  better_thermostat = callPackage ./better_thermostat {};

  bodymiscale = callPackage ./bodymiscale { };

  dwd = callPackage ./dwd { };

  elevenlabs_tts = callPackage ./elevenlabs_tts {};

  emporia_vue = callPackage ./emporia_vue {};

  epex_spot = callPackage ./epex_spot {};

  frigate = callPackage ./frigate {};

  garmin_connect = callPackage ./garmin_connect {};

  govee-lan = callPackage ./govee-lan {};

  gpio = callPackage ./gpio {};

  homematicip_local = callPackage ./homematicip_local { };

  indego = callPackage ./indego { };

  local_luftdaten = callPackage ./local_luftdaten { };

  localtuya = callPackage ./localtuya {};

  mass = callPackage ./mass { };

  midea_ac = callPackage ./midea_ac { };

  midea_ac_lan = callPackage ./midea_ac_lan {};

  midea-air-appliances-lan = callPackage ./midea-air-appliances-lan {};

  miele = callPackage ./miele {};

  moonraker = callPackage ./moonraker {};

  ntfy = callPackage ./ntfy {};

  omnik_inverter = callPackage ./omnik_inverter {};

  prometheus_sensor = callPackage ./prometheus_sensor {};

  samsungtv-smart = callPackage ./samsungtv-smart {};

  sensi = callPackage ./sensi {};

  smartir = callPackage ./smartir {};

  smartthinq-sensors = callPackage ./smartthinq-sensors {};

  solax_modbus = callPackage ./solax_modbus {};

  solis-sensor = callPackage ./solis-sensor {};

  somweb = callPackage ./somweb {};

  spook = callPackage ./spook {};

  tuya_local = callPackage ./tuya_local {};

  volkswagen_we_connect_id = callPackage ./volkswagen_we_connect_id { };

  volkswagencarnet = callPackage ./volkswagencarnet { };

  waste_collection_schedule = callPackage ./waste_collection_schedule {};

  xiaomi_gateway3 = callPackage ./xiaomi_gateway3 {};

  xiaomi_miot = callPackage ./xiaomi_miot {};

  yassi = callPackage ./yassi {};
}
