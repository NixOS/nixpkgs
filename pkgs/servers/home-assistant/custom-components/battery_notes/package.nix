{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  colorlog,
  ruff,
}:

buildHomeAssistantComponent rec {
  owner = "andrew-codechimp";
  domain = "battery_notes";
  version = "2.8.3";

  src = fetchFromGitHub {
    owner = "andrew-codechimp";
    repo = "HA-Battery-Notes";
    tag = version;
    hash = "sha256-6CgIZS/Qmz0EP3s5uOErlDhRBSnmEuPsGXpyJwXU3AM=";
  };

  dependencies = [
    colorlog
    ruff
  ];

  meta = {
    changelog = "https://github.com/andrew-codechimp/HA-Battery-Notes/releases/tag/v${version}";
    description = ''
      A Home Assistant integration to provide battery notes of devices
    '';
    homepage = "https://github.com/andrew-codechimp/HA-Battery-Notes";
    maintainers = with lib.maintainers; [ matthiasbeyer ];
    license = lib.licenses.mit;
  };
}
