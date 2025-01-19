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
    rev = "e24de3f5cd6ec5cef17dc3e07dfb3bfac8867e08";
    sha256 = "sha256-MbVYIsO2m0O5FriF5HphNhLcazgAJzIsl0aVd2YQGaA=";
  };
  meta = {
    homepage = "https://github.com/discourse/discourse-github";
    maintainers = with lib.maintainers; [ talyz ];
    license = lib.licenses.mit;
    description = "Adds GitHub badges and linkback functionality";
  };

}
