{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-migratepassword";
  bundlerEnvArgs.gemdir = ./.;
  src = fetchFromGitHub {
    owner = "communiteq";
    repo = "discourse-migratepassword";
    rev = "a95ae6bca4126172186fafcd2315f51a4504c23b";
    sha256 = "sha256-lr2xHz+8q4XnHc/7KLX0Z2m0KMffLgGYk36zxGG9X5o=";
  };
  meta = with lib; {
    homepage = "https://github.com/communiteq/discourse-migratepassword";
    maintainers = with maintainers; [ ryantm ];
    license = licenses.gpl2Only;
    description = "Support migrated password hashes";
  };
}
