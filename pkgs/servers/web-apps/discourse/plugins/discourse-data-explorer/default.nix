{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-data-explorer";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-data-explorer";
    rev = "06193f27ef15828479eea61ae4a80bf59806a535";
    sha256 = "sha256-afjqgi2gzRpbZt5K9yXPy4BJ5qRv7A4ZkXHX85+Cv7s=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-data-explorer";
    maintainers = with maintainers; [ ryantm ];
    license = licenses.mit;
    description = "SQL Queries for admins in Discourse";
  };
}
