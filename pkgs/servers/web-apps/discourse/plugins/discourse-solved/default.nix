{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-solved";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-solved";
    rev = "8580f96fdf64abf8b22fa4b28d67a4cb0d72fc42";
    sha256 = "sha256-YpUybEXQuPeDxxdX9dMNw4h6Mh/zNUaiR3bwzck5Urg=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-solved";
    maintainers = with maintainers; [ talyz ];
    license = licenses.mit;
    description = "Allow accepted answers on topics";
  };
}
