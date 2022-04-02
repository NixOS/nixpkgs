{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-voting";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-voting";
    rev = "6a4b2a306928191c9ef9f3efdafeb9b4df496bcb";
    sha256 = "sha256-OAn+NS64BcOlhmFYXV0Bq+O1B4a9FKHyN44vbHSax3Y=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-voting";
    maintainers = with maintainers; [ dpausp ];
    license = licenses.gpl2Only;
    description = "Adds the ability for voting on a topic within a specified category in Discourse";
  };
}
