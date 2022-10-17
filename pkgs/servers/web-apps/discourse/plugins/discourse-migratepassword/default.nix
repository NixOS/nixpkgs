{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-migratepassword";
  bundlerEnvArgs.gemdir = ./.;
  src = fetchFromGitHub {
    owner = "communiteq";
    repo = "discourse-migratepassword";
    rev = "ebb705d2f86dea862d6492ae8da5ececca4fde1c";
    sha256 = "sha256-UByhKdIYvwlo8tA9JTK6EGKo7QGkcKIFBVgsgHGIFc0=";
  };
  meta = with lib; {
    homepage = "https://github.com/communiteq/discourse-migratepassword";
    maintainers = with maintainers; [ ryantm ];
    license = licenses.gpl2Only;
    description = "Support migrated password hashes";
  };
}
