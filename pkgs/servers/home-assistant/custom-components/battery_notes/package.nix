{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent rec {
  owner = "andrew-codechimp";
  domain = "battery_notes";
  version = "3.5.1";

  src = fetchFromGitHub {
    inherit owner;
    repo = "HA-Battery-Notes";
    tag = version;
    hash = "sha256-AgGP/4MhoLXInSMCWUYyXfEd2eg6opf84qLqr9YP1RM=";
  };

  # has no tests
  doCheck = false;

  meta = {
    description = "Home Assistant integration to provide battery details of devices";
    homepage = "https://github.com/andrew-codechimp/HA-Battery-Notes";
    changelog = "https://github.com/andrew-codechimp/HA-Battery-Notes/releases/tag/${src.tag}";
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    license = lib.licenses.mit;
  };
}
