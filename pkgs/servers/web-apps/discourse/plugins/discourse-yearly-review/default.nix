{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-yearly-review";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-yearly-review";
    rev = "cb9a2df92788b0a285a595d4acf1749620f62974";
    sha256 = "sha256-Hu61ULEXUxb/cjH7Z47hpBchyUTkz0QqunWoW8mSVQg=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-yearly-review";
    maintainers = with maintainers; [ talyz ];
    license = licenses.mit;
    description = "Publishes an automated Year in Review topic";
  };
}
