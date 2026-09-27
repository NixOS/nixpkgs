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
  version = "2026.09.2";

  src = fetchFromGitHub {
    owner = "wills106";
    repo = "homeassistant-solax-modbus";
    tag = version;
    hash = "sha256-WxSzlcnwQ32qN1azPKjcfDaPTP1Vpfmc8FbF9XEK9kk=";
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
