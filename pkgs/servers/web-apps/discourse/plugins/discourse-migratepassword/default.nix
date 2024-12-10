{
  lib,
  mkDiscoursePlugin,
  fetchFromGitHub,
}:

mkDiscoursePlugin {
  name = "discourse-migratepassword";
  bundlerEnvArgs.gemdir = ./.;
  src = fetchFromGitHub {
    owner = "communiteq";
    repo = "discourse-migratepassword";
    rev = "a732ae244cd4125561fd225a67bae95ef5f738d0";
    sha256 = "sha256-EO+QnFTy3PgxZ92DZBm9sP8sFAny3ZpFw+faTX32j7Q=";
  };
  meta = with lib; {
    homepage = "https://github.com/communiteq/discourse-migratepassword";
    maintainers = with maintainers; [ ryantm ];
    license = licenses.gpl2Only;
    description = "Support migrated password hashes";
  };
}
