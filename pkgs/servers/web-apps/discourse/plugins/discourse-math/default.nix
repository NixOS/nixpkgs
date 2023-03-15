{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-math";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-math";
    rev = "69494ca5a4d708e16e35f1daebeaa53e3edbca2c";
    sha256 = "sha256-C0iVUwj+Lbe6TGfkbu6WxdCeMWVjBaejUh6fXVTqq08=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-math";
    maintainers = with maintainers; [ talyz ];
    license = licenses.mit;
    description = "Official MathJax support for Discourse";
  };
}
