{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-spoiler-alert";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-spoiler-alert";
    rev = "a5fdb9096d638ac4a2a3f8ea6b02b6cb04c667d8";
    sha256 = "sha256-S2Xtd/csB1YI85OA+2UO+OgF5u75Oi2YgIukQNOTQjk=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-spoiler-alert";
    maintainers = with maintainers; [ talyz ];
    license = licenses.mit;
    description = "Hide spoilers behind the spoiler-alert jQuery plugin";
  };
}
