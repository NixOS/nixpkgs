{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-chat-integration";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-chat-integration";
    rev = "820d04d1b2f0c31fc16abf791b0af3a1036be84f";
    sha256 = "sha256-2mIKTuWqx01vNpD9fEBN1UBAf0sXTKAijZNoVG7HBdA=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-chat-integration";
    maintainers = with maintainers; [ dpausp ];
    license = licenses.mit;
    description = "This plugin integrates Discourse with a number of external chatroom systems";
  };
}
