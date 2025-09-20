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
    rev = "d779202749e56aaee2d548b538796fb5db1b9b7c";
    sha256 = "sha256-8YF7W5SXhI7TGJNZkx5or7bxI0MKiDtx10TE2ekBMuM=";
  };
  meta = {
    homepage = "https://github.com/discourse/discourse-voting";
    maintainers = with lib.maintainers; [ dpausp ];
    license = lib.licenses.gpl2Only;
    description = "Adds the ability for voting on a topic within a specified category in Discourse";
  };
}
