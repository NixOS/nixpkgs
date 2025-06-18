{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "periods";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "xocolatl";
    repo = "periods";
    tag = "v${finalAttrs.version}";
    hash = "sha256-97v6+WNDcYb/KivlE/JBlRIZ3gYHj68AlK0fylp1cPo=";
  };

  meta = {
    description = "PostgreSQL extension implementing SQL standard functionality for PERIODs and SYSTEM VERSIONING";
    homepage = "https://github.com/xocolatl/periods";
    maintainers = with lib.maintainers; [ ivan ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.postgresql;
  };
})
