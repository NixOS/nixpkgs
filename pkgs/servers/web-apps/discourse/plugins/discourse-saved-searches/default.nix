{
  lib,
  mkDiscoursePlugin,
  fetchFromGitHub,
}:

mkDiscoursePlugin {
  name = "discourse-saved-searches";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-saved-searches";
    rev = "b78aae086e95255b1a1e91a01e2d56b45b7aead2";
    sha256 = "sha256-Wai+oZR+Pzjre6Th0kQDgvFOwfPRHlZkpKYYOUKNlx4=";
  };
  meta = {
    homepage = "https://github.com/discourse/discourse-saved-searches";
    maintainers = with lib.maintainers; [ dpausp ];
    license = lib.licenses.mit;
    description = "Allow users to save searches and be notified of new results";
  };
}
