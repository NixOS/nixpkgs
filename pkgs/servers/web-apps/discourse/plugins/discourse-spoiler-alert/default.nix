{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-spoiler-alert";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-spoiler-alert";
    rev = "a7727a1c6b6f921365e1cee802e0c16512bbf8ee";
    sha256 = "sha256-60Sg8C7a4vXq/IApcskL0hgceoIHhWqACphcgfrbNig=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-spoiler-alert";
    maintainers = with maintainers; [ talyz ];
    license = licenses.mit;
    description = "Hide spoilers behind the spoiler-alert jQuery plugin";
  };
}
