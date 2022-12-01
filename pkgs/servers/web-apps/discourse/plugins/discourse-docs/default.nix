{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-docs";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-docs";
    rev = "f1dd03f0bc283b86b6028b76ae0841a2a7f9c2a8";
    sha256 = "sha256-Mp1nrmMa0IUE5avR+Q72eIqM7Erb2xid4PYRJWXrUhw=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-docs";
    maintainers = with maintainers; [ dpausp ];
    license = licenses.mit;
    description = "Find and filter knowledge base topics";
  };
}
