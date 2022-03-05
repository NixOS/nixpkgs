{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-assign";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-assign";
    rev = "ffe95da7ed0cf0893a76af37498784ad92041131";
    sha256 = "sha256-FdZATO1Z6XmhForETZ2FC+6wfR437cpRg8QSFzmbsxQ=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-docs";
    maintainers = with maintainers; [ dpausp ];
    license = licenses.mit;
    description = "Discourse Plugin for assigning users to a topic";
  };
}
