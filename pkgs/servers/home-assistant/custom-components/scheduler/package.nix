{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent rec {
  owner = "nielsfaber";
  domain = "scheduler";
  version = "3.3.8";

  src = fetchFromGitHub {
    owner = "nielsfaber";
    repo = "scheduler-component";
    tag = "v${version}";
    hash = "sha256-QN7rkNuj9IBbV2ths7ZdL/EkXFJUpjNbgJNUnAHjLBA=";
  };

  dontBuild = true;

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "Custom component for HA that enables the creation of scheduler entities";
    homepage = "https://github.com/nielsfaber/scheduler-component";
    changelog = "https://github.com/nielsfaber/scheduler-component/releases/tag/v${version}";
    maintainers = with maintainers; [ SuperSandro2000 ];
    license = licenses.gpl3Plus;
  };
}
