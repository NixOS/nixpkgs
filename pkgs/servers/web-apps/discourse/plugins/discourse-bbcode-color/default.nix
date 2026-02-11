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
    rev = "2e32fe4573912612ab61cf9c1962f3ae85fd732a";
    sha256 = "sha256-7M2K3yx1CwzrLgS83e/3YKGyGJA4S7wT2QG7m9yZNnI=";
  };
  meta = {
    homepage = "https://github.com/discourse/discourse-bbcode-color";
    maintainers = with lib.maintainers; [ ryantm ];
    license = lib.licenses.mit;
    description = "Support BBCode color tags";
  };
}
