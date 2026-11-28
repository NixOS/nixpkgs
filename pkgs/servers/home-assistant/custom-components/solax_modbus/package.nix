{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  pymodbus,
  tmodbus,
}:

buildHomeAssistantComponent rec {
  owner = "wills106";
  domain = "solax_modbus";
  version = "2026.11.04";

  src = fetchFromGitHub {
    owner = "wills106";
    repo = "homeassistant-solax-modbus";
    tag = version;
    hash = "sha256-sHT8h/vOTD/Y730An/3OpfWB8ZghZ/78F528IZodTUI=";
  };

  ignoreVersionRequirement = [
    "tmodbus"
  ];

  dependencies = [
    pymodbus
    tmodbus
  ];

  meta = {
    changelog = "https://github.com/wills106/homeassistant-solax-modbus/releases/tag/${version}";
    description = "SolaX Power Modbus custom_component for Home Assistant (Supports some Ginlong Solis, Growatt, Sofar Solar, TIGO TSI & Qcells Q.Volt Hyb)";
    homepage = "https://github.com/wills106/homeassistant-solax-modbus";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ Luflosi ];
  };
}
