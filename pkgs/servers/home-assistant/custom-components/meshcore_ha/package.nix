{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  ruff,
  meshcore,
  meshcore-cli,
}:

buildHomeAssistantComponent rec {
  owner = "meshcore-dev";
  domain = "meshcore";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "meshcore-dev";
    repo = "meshcore-ha";
    tag = "v${version}";
    hash = "sha256-+DOekvuhd3M00cRNBsWiI+idz80JFQ7XPQ6g4Ecq2R0=";
  };

  dependencies = [
    meshcore
    meshcore-cli
  ];

  meta = {
    description = "Home Assistant integration for MeshCore";
    homepage = "https://github.com/meshcore-dev/meshcore-ha/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.haylin ];
  };
}
