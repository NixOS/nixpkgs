{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent rec {
  owner = "Limych";
  domain = "average";
  version = "2.4.0";

  src = fetchFromGitHub {
    inherit owner;
    repo = "ha-average";
    tag = version;
    hash = "sha256-LISGpgfoVxdOeJ9LHzxf7zt49pbIJrLiPkNg/Mf1lxM=";
  };

  postPatch = ''
    sed -i "/pip>=/d" custom_components/average/manifest.json
  '';

  meta = with lib; {
    changelog = "https://github.com/Limych/ha-average/releases/tag/${version}";
    description = "Average Sensor for Home Assistant";
    homepage = "https://github.com/Limych/ha-average";
    maintainers = with maintainers; [ matthiasbeyer ];
    license = licenses.cc-by-nc-40;
  };
}
