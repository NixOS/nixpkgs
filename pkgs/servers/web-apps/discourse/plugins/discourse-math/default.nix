{
  lib,
  mkDiscoursePlugin,
  fetchFromGitHub,
}:

mkDiscoursePlugin {
  name = "discourse-math";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-math";
    rev = "19ab34b62ab75589419ee39af7d6ba2fec1bdc4a";
    sha256 = "sha256-Z6+Bx1DKEE+s1flt5K/HfevzXsA+mA0YfQxmg7JQMfA=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-math";
    maintainers = with maintainers; [ talyz ];
    license = licenses.mit;
    description = "Official MathJax support for Discourse";
  };
}
