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
    rev = "a4e9ee393de923332609d0436e3c1c8757f6cb1c";
    sha256 = "sha256-WHU7vYTnavX3waJWjHn11kg70TCoFH9cdmdPRSsNZO4=";
  };
  meta = {
    homepage = "https://github.com/discourse/discourse-yearly-review";
    maintainers = with lib.maintainers; [ talyz ];
    license = lib.licenses.mit;
    description = "Publishes an automated Year in Review topic";
  };
}
