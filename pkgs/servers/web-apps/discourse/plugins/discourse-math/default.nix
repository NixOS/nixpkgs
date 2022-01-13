{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-math";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-math";
    rev = "33662c4b1d8a3faa6138261bd6a6043b4d9ac037";
    sha256 = "sha256-UMGj2KqYHs7MtVHBGLUgUKA7wzhX32160b4OihiwgCI=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-math";
    maintainers = with maintainers; [ talyz ];
    license = licenses.mit;
    description = "Official MathJax support for Discourse";
  };
}
