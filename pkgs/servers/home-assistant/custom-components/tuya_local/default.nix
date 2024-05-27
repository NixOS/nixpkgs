{ lib
, buildHomeAssistantComponent
, fetchFromGitHub

# dependencies
, tinytuya
}:

buildHomeAssistantComponent rec {
  owner = "make-all";
  domain = "tuya_local";
  version = "2024.5.2";

  src = fetchFromGitHub {
    inherit owner;
    repo = "tuya-local";
    rev = "refs/tags/${version}";
    hash = "sha256-If5SLLizagolXF5Y43UQK5IZ9oB1lQJVjTorgmtRXtg=";
  };

  dependencies = [ tinytuya ];

  meta = with lib; {
    description = "Local support for Tuya devices in Home Assistant";
    homepage = "https://github.com/make-all/tuya-local";
    changelog = "https://github.com/make-all/tuya-local/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ pathob ];
  };
}
