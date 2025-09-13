{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  aenum,
  nix-update-script,
}:

buildHomeAssistantComponent rec {
  owner = "jeatheak";
  domain = "mitsubishi_wf_rac";
  version = "2024.12";

  src = fetchFromGitHub {
    owner = "jeatheak";
    repo = "Mitsubishi-WF-RAC-Integration";
    rev = version;
    hash = "sha256-0d3Dvbu0xJJRyHBsxOQMu3q7FaNiNTtVLRxX6AT+zyQ=";
  };

  dependencies = [ aenum ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Home Assistant custom component for Mitsubishi WF-RAC air conditioning units";
    homepage = "https://github.com/jeatheak/Mitsubishi-WF-RAC-Integration";
    license = licenses.mit;
    maintainers = with maintainers; [ graham33 ];
  };
}
