{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-math";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-math";
    rev = "cacbd04bb239db3c772ff5a37c19fe39d127ff3d";
    sha256 = "sha256-Le2NlWcKvI1kFe8Ld92VNzl5a+B0GmiWcC2TRTU/Gq4=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-math";
    maintainers = with maintainers; [ talyz ];
    license = licenses.mit;
    description = "Official MathJax support for Discourse";
  };
}
