{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-math";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-math";
    rev = "cacbd04bb239db3c772ff5a37c19fe39d127ff3d";
    sha256 = "1bhs7wslb4rdf2b6h6klw1mpjf9pjpfpf2zg2mj8vg0acyaqvv9d";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-math";
    maintainers = with maintainers; [ talyz ];
    license = licenses.mit;
    description = "Official MathJax support for Discourse";
  };
}
