{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-docs";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-docs";
    rev = "0b4d2f3691048b6e0e257a1ac9ed01f66f662ba8";
    sha256 = "sha256-HeIUCTbMNpuo6zeaDClsGrUOz4m0L+4UK7AwPsrKIHY=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-docs";
    maintainers = with maintainers; [ dpausp ];
    license = licenses.mit;
    description = "Find and filter knowledge base topics";
  };
}
