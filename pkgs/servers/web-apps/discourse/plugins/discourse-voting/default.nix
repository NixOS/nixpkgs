{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-voting";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-voting";
    rev = "36a41c2969c1ddfd8980e3f766b730b849726a08";
    sha256 = "0ns2i8liwpd29kbn44wzx9yb0jfpyz70h0hmrs71hz6fdalzm4ph";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-voting";
    maintainers = with maintainers; [ dpausp ];
    license = licenses.gpl2Only;
    description = "Adds the ability for voting on a topic within a specified category in Discourse";
  };
}
