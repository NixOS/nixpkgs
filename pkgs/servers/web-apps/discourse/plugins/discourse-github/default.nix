{
  lib,
  mkDiscoursePlugin,
  fetchFromGitHub,
}:

mkDiscoursePlugin {
  name = "discourse-github";
  bundlerEnvArgs.gemdir = ./.;
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-github";
    rev = "59e5fc5692959c6c564ab0e09de364ccfedd6702";
    sha256 = "sha256-b+8eSw8Kbz2CZN16Rd7c8uyH5P1iYhOJmdXu1C5UclU=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-github";
    maintainers = with maintainers; [ talyz ];
    license = licenses.mit;
    description = "Adds GitHub badges and linkback functionality";
  };

}
