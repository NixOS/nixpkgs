{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  pymodbus,
}:

buildHomeAssistantComponent rec {
  owner = "wills106";
  domain = "solax_modbus";
  version = "2025.06.1";

  src = fetchFromGitHub {
    owner = "wills106";
    repo = "homeassistant-solax-modbus";
    tag = version;
    hash = "sha256-aKbd/eNzROHF4evFS4sH8+dJwj5f3xZsF4qjTzHIu9g=";
  };

  postPatch = ''
    substituteInPlace custom_components/solax_modbus/payload.py --replace-fail \
      'from pymodbus.utilities import (' \
      'from pymodbus.pdu.pdu import ('
  '';

  dependencies = [ pymodbus ];

  meta = {
    changelog = "https://github.com/wills106/homeassistant-solax-modbus/releases/tag/${version}";
    description = "SolaX Power Modbus custom_component for Home Assistant (Supports some Ginlong Solis, Growatt, Sofar Solar, TIGO TSI & Qcells Q.Volt Hyb)";
    homepage = "https://github.com/wills106/homeassistant-solax-modbus";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ Luflosi ];
  };
}
