{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-checklist";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-checklist";
    rev = "c97060bd9dc1287d258cac6b7222a9a61d4f97c7";
    sha256 = "sha256-fVGTYz/2PK5rq/7SE/hkQoWYiIzOcmZ9AHNe5f+osxY=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-checklist";
    maintainers = with maintainers; [ ryantm ];
    license = licenses.gpl2Only;
    description = "A simple checklist rendering plugin for discourse ";
  };
}
