{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin rec {
  name = "discourse-oauth2-basic";
  bundlerEnvArgs.gemdir = ./.;
  src = fetchFromGitHub {
    owner = "discourse";
    repo = name;
    rev = "06ba5daa9aabd0487f2f30b944b6500f1f481308";
    sha256 = "sha256-T08Q36k2hb9wVimKIa4O5mWcrr6VBTfHvhRJiLBiRPY=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/${name}";
    maintainers = with maintainers; [ ehmry ];
    license = licenses.mit;
    description = "A basic OAuth2 plugin for use with Discourse";
  };
}
