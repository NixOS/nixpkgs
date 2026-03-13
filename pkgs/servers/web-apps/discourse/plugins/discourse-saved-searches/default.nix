{
  lib,
  mkDiscoursePlugin,
  fetchFromGitHub,
}:

mkDiscoursePlugin {
  name = "discourse-saved-searches";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-saved-searches";
    rev = "d13a708d33fc24bb6cc111e8d84fb896caf81ef4";
    sha256 = "sha256-3hnmtHR1k1bZKH3ezauQPr7pfbQYRTbGV8a39w6m6F8=";
  };
  meta = {
    homepage = "https://github.com/discourse/discourse-saved-searches";
    maintainers = with lib.maintainers; [ dpausp ];
    license = lib.licenses.mit;
    description = "Allow users to save searches and be notified of new results";
  };
}
