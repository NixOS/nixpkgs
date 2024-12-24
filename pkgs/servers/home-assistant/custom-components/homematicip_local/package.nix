{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  hahomematic,
  home-assistant,
}:

buildHomeAssistantComponent rec {
  owner = "danielperna84";
  domain = "homematicip_local";
  version = "1.75.0";

  src = fetchFromGitHub {
    owner = "danielperna84";
    repo = "custom_homematic";
    rev = "refs/tags/${version}";
    hash = "sha256-H5Gf09C9/s2JYVTjgiYNe28mV18mqTiJ0ZDR6rnuojo=";
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
    changelog = "https://github.com/danielperna84/custom_homematic/blob/${version}/changelog.md";
    description = "Custom Home Assistant Component for HomeMatic";
    homepage = "https://github.com/danielperna84/custom_homematic";
    maintainers = with lib.maintainers; [ dotlambda ];
    license = lib.licenses.mit;
  };
}
