{
  bash,
  fetchFromGitHub,
  lib,
  libsodium,
  postgresql,
  postgresqlBuildExtension,
  postgresqlTestExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pgsodium";
  version = "3.1.9";

  src = fetchFromGitHub {
    owner = "michelp";
    repo = "pgsodium";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y8xL3PxF1GQV1JIgolMI1e8oGcUvWAgrPv84om7wKP8=";
  };

  buildInputs = [
    bash # required for patchShebangs
    libsodium
  ];

  postInstall = ''
    install -D -t $out/share/pgsodium/getkey_scripts getkey_scripts/*
    ln -s $out/share/pgsodium/getkey_scripts/pgsodium_getkey_urandom.sh $out/share/postgresql/extension/pgsodium_getkey
  '';

  passthru.tests.extension = postgresqlTestExtension {
    inherit (finalAttrs) finalPackage;
    postgresqlExtraSettings = ''
      shared_preload_libraries=pgsodium
    '';
    sql = ''
      CREATE EXTENSION pgsodium;

      SELECT pgsodium.version();
      SELECT pgsodium.crypto_auth_keygen();
      SELECT pgsodium.randombytes_random() FROM generate_series(0, 5);
      SELECT * FROM pgsodium.crypto_box_new_keypair();
    '';
  };

  meta = {
    description = "Modern cryptography for PostgreSQL using libsodium";
    homepage = "https://github.com/michelp/pgsodium";
    changelog = "https://github.com/michelp/pgsodium/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.postgresql;
    maintainers = [ ];
    platforms = postgresql.meta.platforms;
  };
})
