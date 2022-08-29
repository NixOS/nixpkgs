{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-migratepassword";
  bundlerEnvArgs.gemdir = ./.;
  src = fetchFromGitHub {
    owner = "communiteq";
    repo = "discourse-migratepassword";
    rev = "7d33a57b4bd2a37badc64d5eca57d7ca01d62937";
    sha256 = "sha256-BDBXgsLVHYiSSjvN4Y13ffwfWk6nuVLoJE1YKgGmLTA=";
  };
  meta = with lib; {
    homepage = "https://github.com/communiteq/discourse-migratepassword";
    maintainers = with maintainers; [ ryantm ];
    license = licenses.gpl2Only;
    description = "Support migrated password hashes";
  };
}
