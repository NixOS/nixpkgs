{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  hahomematic,
  home-assistant,
}:

buildHomeAssistantComponent rec {
  owner = "SukramJ";
  domain = "homematicip_local";
  version = "1.78.0";

  src = fetchFromGitHub {
    owner = "SukramJ";
    repo = "custom_homematic";
    tag = version;
    hash = "sha256-WhY+JxX2uUk5pgraqAZqa/NB9lozXbTHr/szXUKAn48=";
  };

  postPatch = ''
    min_ha_version="$(sed -nr 's/^HMIP_LOCAL_MIN_HA_VERSION.*= "([0-9.]+)"$/\1/p' custom_components/homematicip_local/const.py)"
    test \
      "$(printf '%s\n' "$min_ha_version" "${home-assistant.version}" | sort -V | head -n1)" = "$min_ha_version" \
      || (echo "error: only Home Assistant >= $min_ha_version is supported" && exit 1)
  '';

  dependencies = [
    hahomematic
  ];

  meta = {
    changelog = "https://github.com/SukramJ/custom_homematic/blob/${src.tag}/changelog.md";
    description = "Custom Home Assistant Component for HomeMatic";
    homepage = "https://github.com/SukramJ/custom_homematic";
    maintainers = with lib.maintainers; [ dotlambda ];
    license = lib.licenses.mit;
  };
}
