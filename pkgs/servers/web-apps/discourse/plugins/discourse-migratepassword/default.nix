{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-migratepassword";
  bundlerEnvArgs.gemdir = ./.;
  src = fetchFromGitHub {
    owner = "communiteq";
    repo = "discourse-migratepassword";
    rev = "32d5fca6de3e8daf3869696ce835fefca1f00bfa";
    sha256 = "sha256-kNYkA6zuiuUZlPgvIvaO49P8bD+nNysEsow33xG1PnI=";
  };
  meta = with lib; {
    homepage = "https://github.com/communiteq/discourse-migratepassword";
    maintainers = with maintainers; [ ryantm ];
    license = licenses.gpl2Only;
    description = "Support migrated password hashes";
  };
}
