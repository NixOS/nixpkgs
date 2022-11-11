{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-checklist";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-checklist";
    rev = "4fb02010235b7d6e8d9a50b007fc42afb4a064bc";
    sha256 = "sha256-Tzz9di8a6wJwyqb8G7z5K95YLqteNssZ8S/5nAOu84I=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-checklist";
    maintainers = with maintainers; [ ryantm ];
    license = licenses.gpl2Only;
    description = "A simple checklist rendering plugin for discourse ";
  };
}
