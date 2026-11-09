{
  lib,
  mkDiscoursePlugin,
  fetchFromGitHub,
}:

mkDiscoursePlugin {
  name = "discourse-docs";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-docs";
    rev = "5764be5b8ce440df9059f05cf6273c50f90f7905";
    sha256 = "sha256-BXeWJuokl9FnE1wtpJZ1e1AsU2MhO65I8vkRf1nF76I=";
  };
  meta = {
    homepage = "https://github.com/discourse/discourse-docs";
    license = lib.licenses.mit;
    description = "Find and filter knowledge base topics";
  };
}
