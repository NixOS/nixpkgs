{
  lib,
  mkDiscoursePlugin,
  fetchFromGitHub,
}:

mkDiscoursePlugin {
  name = "discourse-voting";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-topic-voting";
    rev = "b31bc6e037af776d2cea3f34c44b02a105b34d24";
    sha256 = "sha256-835xFg2NnhE4HPju2j3w+N5rtRYinOBbBMerRJpnpxQ=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-voting";
    maintainers = with maintainers; [ dpausp ];
    license = licenses.gpl2Only;
    description = "Adds the ability for voting on a topic within a specified category in Discourse";
  };
}
