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
    rev = "ecd4befeb4eae48aa0a37a88e5aca60e59730411";
    sha256 = "sha256-enpeXc6pE9+5EdbMIFsnWd++ixlHBKFRxbXmvJYJftg=";
  };
  meta = {
    homepage = "https://github.com/discourse/discourse-bbcode-color";
    maintainers = with lib.maintainers; [ ryantm ];
    license = lib.licenses.mit;
    description = "Support BBCode color tags";
  };
}
