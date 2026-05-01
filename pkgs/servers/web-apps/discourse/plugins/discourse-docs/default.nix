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
    rev = "742515b059c27803a7b813ae420b65ceba1e8798";
    sha256 = "sha256-AG4WYskmEdW68n2XX4t139I3rlc0PNAL8cTehVvEgAs=";
  };
  meta = {
    homepage = "https://github.com/discourse/discourse-docs";
    maintainers = with lib.maintainers; [ dpausp ];
    license = lib.licenses.mit;
    description = "Find and filter knowledge base topics";
  };
}
