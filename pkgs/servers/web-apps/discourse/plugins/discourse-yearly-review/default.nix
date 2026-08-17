{
  lib,
  mkDiscoursePlugin,
  fetchFromGitHub,
}:

mkDiscoursePlugin {
  name = "discourse-yearly-review";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-yearly-review";
    rev = "97720c573f04ce32544ef1e9353b12005de0bdec";
    sha256 = "sha256-ZhkrPYFjhtNoh6jQhqPTMZJqHMyZo3tdbtSl3MuOJz0=";
  };
  meta = {
    homepage = "https://github.com/discourse/discourse-yearly-review";
    maintainers = with lib.maintainers; [ talyz ];
    license = lib.licenses.mit;
    description = "Publishes an automated Year in Review topic";
  };
}
