{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-spoiler-alert";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-spoiler-alert";
    rev = "5afbcb905fa2c8cb8b7156ab5df3af27d6e6b477";
    sha256 = "sha256-/Y5ATVSnJ3hMNiiqqYJzitgkQ/2zbWLaPdII9agTa10=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-spoiler-alert";
    maintainers = with maintainers; [ talyz ];
    license = licenses.mit;
    description = "Hide spoilers behind the spoiler-alert jQuery plugin";
  };
}
