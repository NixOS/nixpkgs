{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-checklist";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-checklist";
    rev = "d8012abd3d6dccb72eec83e6a96ef4809dcad681";
    sha256 = "1ngjql65939c571gyaqj8ydcxy5kkril2qlkxqf579vvwzpvxw13";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-checklist";
    maintainers = with maintainers; [ ryantm ];
    license = licenses.gpl2Only;
    description = "A simple checklist rendering plugin for discourse ";
  };
}
