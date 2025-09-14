{
  lib,
  mkDiscoursePlugin,
  fetchFromGitHub,
}:

mkDiscoursePlugin {
  name = "discourse-docs";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-docs";
    rev = "4e42539cda9a54d7827bcdf51b6dfbcf56d24cc9";
    sha256 = "sha256-sv9Q0qEQVncQw3QLiro5YfVcHJAG8sJ0GTjduCZ0iP4=";
  };
  meta = {
    homepage = "https://github.com/discourse/discourse-docs";
    maintainers = with lib.maintainers; [ dpausp ];
    license = lib.licenses.mit;
    description = "Find and filter knowledge base topics";
  };
}
