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
    rev = "218e7290fc32a04d94bb4da29d9c4a8dbd9cc88e";
    sha256 = "sha256-rRMwZw34vodYi3sFIk52GN/gztZkJHc4JGckH2WeBCQ=";
  };
  meta = {
    homepage = "https://github.com/discourse/discourse-yearly-review";
    maintainers = with lib.maintainers; [ talyz ];
    license = lib.licenses.mit;
    description = "Publishes an automated Year in Review topic";
  };
}
