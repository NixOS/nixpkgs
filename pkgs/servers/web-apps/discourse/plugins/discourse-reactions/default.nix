{
  lib,
  mkDiscoursePlugin,
  fetchFromGitHub,
}:

mkDiscoursePlugin {
  name = "discourse-reactions";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-reactions";
    rev = "f87583d9054421869ba0de16c24ad15e32bbebe7";
    sha256 = "sha256-v2AkpSTF3VNgBUfvRMQ3BCw0nClWjcVTdKNn9yiByBM=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-reactions";
    maintainers = with maintainers; [ bbenno ];
    license = licenses.mit;
    description = "Allows users to react to a post from a choice of emojis, rather than only the like heart";
  };
}
