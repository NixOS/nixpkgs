{
  lib,
  mkDiscoursePlugin,
  fetchFromGitHub,
}:

mkDiscoursePlugin {
  name = "discourse-chat-integration";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-chat-integration";
    rev = "428df114ff7f8416314dc585e59bc898ee59c674";
    sha256 = "sha256-pP9MzQz9nghGIPMnGFOEXxW/OH/8BzHltcxAQboLYec=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-chat-integration";
    maintainers = with maintainers; [ dpausp ];
    license = licenses.mit;
    description = "This plugin integrates Discourse with a number of external chatroom systems";
  };
}
