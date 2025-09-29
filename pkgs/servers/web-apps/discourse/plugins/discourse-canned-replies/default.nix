{
  lib,
  mkDiscoursePlugin,
  fetchFromGitHub,
}:

mkDiscoursePlugin {
  name = "discourse-canned-replies";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-canned-replies";
    rev = "732598b6cdc86c74622bb15bfeaebb05611bbc25";
    sha256 = "sha256-t0emNsPT8o0ralUedt33ufH0VLl4/12lVBBCnzfdRxE=";
  };
  meta = {
    homepage = "https://github.com/discourse/discourse-canned-replies";
    maintainers = with lib.maintainers; [ talyz ];
    license = lib.licenses.gpl2Only;
    description = "Adds support for inserting a canned reply into the composer window via a UI";
  };
}
