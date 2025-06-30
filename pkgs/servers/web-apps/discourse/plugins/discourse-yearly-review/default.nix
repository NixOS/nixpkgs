{
  lib,
  mkDiscoursePlugin,
  fetchFromGitHub,
}:

mkDiscoursePlugin {
  name = "discourse-yearly-review";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-yearly-review";
    rev = "439e0d78f1d8a0f387c0ec26f233a090ce82ef72";
    sha256 = "sha256-DXA5P7XnItBjP4H1J/G1cGbFddSDZh0wjMZiJ5JA9s8=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-yearly-review";
    maintainers = with maintainers; [ talyz ];
    license = licenses.mit;
    description = "Publishes an automated Year in Review topic";
  };
}
