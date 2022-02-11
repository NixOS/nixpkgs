{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-data-explorer";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-data-explorer";
    rev = "58cfe737f7eb3d401a059edc8d24ed0ec22fa2f7";
    sha256 = "sha256-pwzW+HCby2HD5SsnFCi8kUqN/dQuZiVkdmqQ2P2XQ2c=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-data-explorer";
    maintainers = with maintainers; [ ryantm ];
    license = licenses.mit;
    description = "SQL Queries for admins in Discourse";
  };
}
