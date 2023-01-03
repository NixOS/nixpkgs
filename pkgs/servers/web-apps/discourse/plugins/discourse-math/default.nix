{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-math";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-math";
    rev = "45563f691aafcd0d76f07db9c105d42f3e3d5ba0";
    sha256 = "sha256-s2mzV1YdUG9vjw1LKm+jZriQfWYN5Jn232z3Cc7NFeg=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-math";
    maintainers = with maintainers; [ talyz ];
    license = licenses.mit;
    description = "Official MathJax support for Discourse";
  };
}
