{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-assign";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-assign";
    rev = "c6e6a883f66670e5cfc1eb973af8ac5b7c20f815";
    sha256 = "sha256-OwNV+ZNogUgd6ZKdXwUqoMqcZKc4jbf276rHIYQzjYc=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-docs";
    maintainers = with maintainers; [ dpausp ];
    license = licenses.mit;
    description = "Discourse Plugin for assigning users to a topic";
  };
}
