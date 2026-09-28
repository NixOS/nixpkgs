{
  lib,
  mkDiscoursePlugin,
  fetchFromGitHub,
}:

mkDiscoursePlugin {
  name = "discourse-bbcode-color";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-bbcode-color";
    rev = "b68e1c3bfbfe2468f70af47045276e4463568fe3";
    sha256 = "sha256-AM3AMZFaTTf9Q6ulr9qoTZafykPFBTkXvtkmU+TAPew=";
  };
  meta = {
    homepage = "https://github.com/discourse/discourse-bbcode-color";
    maintainers = with lib.maintainers; [ ryantm ];
    license = lib.licenses.mit;
    description = "Support BBCode color tags";
  };
}
