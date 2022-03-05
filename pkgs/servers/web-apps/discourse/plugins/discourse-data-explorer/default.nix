{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-data-explorer";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-data-explorer";
    rev = "2a17f49f66feb7a3068cf6f1e4ad08550f875057";
    sha256 = "sha256-LOcJle0S7Z8oGz1XgTEHiz1JNKufxege+joeinwX7xU=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-data-explorer";
    maintainers = with maintainers; [ ryantm ];
    license = licenses.mit;
    description = "SQL Queries for admins in Discourse";
  };
}
