{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-math";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-math";
    rev = "2deef48ab16bc0a15ab5f1fef98e15261251bf32";
    sha256 = "sha256-Crt7ozasZ1DCwAzaH/Y6BQEXwpX6t9qsIrGYMlECylk=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-math";
    maintainers = with maintainers; [ talyz ];
    license = licenses.mit;
    description = "Official MathJax support for Discourse";
  };
}
