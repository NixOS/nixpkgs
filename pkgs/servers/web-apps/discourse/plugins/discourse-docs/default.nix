{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-docs";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-docs";
    rev = "f8ac536160c662f29c49111beb5b18b70dbe8cd9";
    sha256 = "sha256-pU5Dl+G2HRKfWi+W+P4ZP6A8EMqi9xaIYXx1xUg9I54=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-docs";
    maintainers = with maintainers; [ dpausp ];
    license = licenses.mit;
    description = "Find and filter knowledge base topics";
  };
}
