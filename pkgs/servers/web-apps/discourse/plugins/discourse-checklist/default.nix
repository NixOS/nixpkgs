{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-checklist";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-checklist";
    rev = "80d448b92173398530643ee07a40d6c60e4a3a5e";
    sha256 = "sha256-FJtb7s4UQ6A4SEezB/58pmvpN+f1gVBY/G4GUzE20ME=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-checklist";
    maintainers = with maintainers; [ ryantm ];
    license = licenses.gpl2Only;
    description = "A simple checklist rendering plugin for discourse ";
  };
}
