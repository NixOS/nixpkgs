{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-data-explorer";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-data-explorer";
    rev = "41a5e0a27a06225c401cbbaa24f0f712f7bd7cf7";
    sha256 = "sha256-m1EvNepl9JLoEeUaDXTBHz4G+DDCpdPNgAz+/Lcqn1Q=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-data-explorer";
    maintainers = with maintainers; [ ryantm ];
    license = licenses.mit;
    description = "SQL Queries for admins in Discourse";
  };
}
