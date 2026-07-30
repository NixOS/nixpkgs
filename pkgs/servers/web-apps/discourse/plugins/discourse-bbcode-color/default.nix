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
    rev = "8c621d07a7a60b94d717fd435b0f137e89db99cd";
    sha256 = "sha256-+LqlJpg9s2GbZE136FUDIRn9C10a7IYPPu1crkMqMSA=";
  };
  meta = {
    homepage = "https://github.com/discourse/discourse-bbcode-color";
    maintainers = with lib.maintainers; [ ryantm ];
    license = lib.licenses.mit;
    description = "Support BBCode color tags";
  };
}
