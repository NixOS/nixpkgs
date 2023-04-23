{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-docs";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-docs";
    rev = "bf1c4574a61b053c136e2b181ba2fedb6c16f838";
    sha256 = "sha256-voo3Q+e/Ud1Hg+SdHlvRsxoacFnPOQXwWu/g6n5cR3Y=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-docs";
    maintainers = with maintainers; [ dpausp ];
    license = licenses.mit;
    description = "Find and filter knowledge base topics";
  };
}
