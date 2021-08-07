{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-math";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-math";
    rev = "aed0c83cee568d5239143bcf1df59c5fbe86b276";
    sha256 = "1k6kpnhf8s2l0w9zr5pn3wvn8w0n3gwkv7qkv0mkhkzy246ag20z";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-math";
    maintainers = with maintainers; [ talyz ];
    license = licenses.mit;
    description = "Official MathJax support for Discourse";
  };
}
