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
    rev = "29ad813cd04812786780e1706cbc043810dea7d8";
    sha256 = "sha256-5mGnHLlw3qIGi8et3WV1RXnrPB+bySi3wQryKTa5wNg=";
  };
  meta = {
    homepage = "https://github.com/discourse/discourse-chat-integration";
    maintainers = with lib.maintainers; [ dpausp ];
    license = lib.licenses.mit;
    description = "This plugin integrates Discourse with a number of external chatroom systems";
  };
}
