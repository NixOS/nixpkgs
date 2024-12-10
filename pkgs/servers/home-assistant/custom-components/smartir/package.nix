{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  fetchpatch,
  aiofiles,
  broadlink,
  nix-update-script,
}:

buildHomeAssistantComponent rec {
  owner = "smartHomeHub";
  domain = "smartir";
  version = "1.17.9";

  src = fetchFromGitHub {
    owner = "smartHomeHub";
    repo = "SmartIR";
    rev = version;
    hash = "sha256-E6TM761cuaeQzlbjA+oZ+wt5HTJAfkF2J3i4P1Wbuic=";
  };

  patches = [
    # Replace distutils.version.StrictVersion with packaging.version.Version
    # https://github.com/smartHomeHub/SmartIR/pull/1250
    (fetchpatch {
      url = "https://github.com/smartHomeHub/SmartIR/commit/1ed8ef23a8f7b9dcae75721eeab8d5f79013b851.patch";
      hash = "sha256-IhdnTDtUa7mS+Vw/+BqfqWIKK4hbshbVgJNjfKjgAvI=";
    })
  ];

  propagatedBuildInputs = [
    aiofiles
    broadlink
  ];

  dontBuild = true;

  postInstall = ''
    cp -r codes $out/custom_components/smartir/
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    changelog = "https://github.com/smartHomeHub/SmartIR/releases/tag/v${version}";
    description = "Integration for Home Assistant to control climate, TV and fan devices via IR/RF controllers (Broadlink, Xiaomi, MQTT, LOOKin, ESPHome)";
    homepage = "https://github.com/smartHomeHub/SmartIR";
    maintainers = with maintainers; [ azuwis ];
    license = licenses.mit;
  };
}
