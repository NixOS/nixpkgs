{
  lib,
  mkDiscoursePlugin,
  fetchFromGitHub,
}:

mkDiscoursePlugin {
  name = "discourse-data-explorer";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-data-explorer";
    rev = "b61e81fb616ce5880af96584ab9175f07f6362d4";
    sha256 = "sha256-4E2PR7RwoM/e6cJFuaorK6EYe1nSDKkorJWrlWPzg3g=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-data-explorer";
    maintainers = with maintainers; [ ryantm ];
    license = licenses.mit;
    description = "SQL Queries for admins in Discourse";
  };
}
