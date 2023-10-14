{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-docs";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-docs";
    rev = "89c7274b1a730edefd1b56c13b8c04305d4ef331";
    sha256 = "sha256-j3zrGmoAvbSHFnbiUfetyfiQJebrtW3Iw5GvsRRq1kk=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-docs";
    maintainers = with maintainers; [ dpausp ];
    license = licenses.mit;
    description = "Find and filter knowledge base topics";
  };
}
