{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-bbcode-color";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-bbcode-color";
    rev = "e58c38930122772aef15738676683f7d7ff68411";
    sha256 = "sha256-/uHJ9HMXx7YMYsAc3t/s//ucI8I9Wh3wtC/dQCbtbGU=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-bbcode-color";
    maintainers = with maintainers; [ ryantm ];
    license = licenses.mit;
    description = "Support BBCode color tags.";
  };
}
