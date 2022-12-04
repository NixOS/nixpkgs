{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-math";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-math";
    rev = "b5d2a8a3ea302e0d8d43e1fcba5aa455e792475f";
    sha256 = "sha256-VzvPX8u1ABhzgdsH+ytaCdEkge6dvMfDZ9EyCxfU25o=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-math";
    maintainers = with maintainers; [ talyz ];
    license = licenses.mit;
    description = "Official MathJax support for Discourse";
  };
}
