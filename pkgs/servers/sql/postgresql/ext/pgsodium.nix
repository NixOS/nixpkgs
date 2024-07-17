{
  lib,
  stdenv,
  fetchFromGitHub,
  libsodium,
  postgresql,
  postgresqlTestHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pgsodium";
  version = "3.1.9";

  src = fetchFromGitHub {
    owner = "michelp";
    repo = "pgsodium";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Y8xL3PxF1GQV1JIgolMI1e8oGcUvWAgrPv84om7wKP8=";
  };

  buildInputs = [
    libsodium
    postgresql
  ];

  installPhase = ''
    runHook preInstall

    install -D -t $out/lib pgsodium${postgresql.dlSuffix}
    install -D -t $out/share/postgresql/extension sql/pgsodium-*.sql
    install -D -t $out/share/postgresql/extension pgsodium.control

    install -D -t $out/share/pgsodium/getkey_scripts getkey_scripts/*
    ln -s $out/share/pgsodium/getkey_scripts/pgsodium_getkey_urandom.sh $out/share/postgresql/extension/pgsodium_getkey

    runHook postInstall
  '';

  passthru.tests.extension = stdenv.mkDerivation {
    name = "pgsodium-test";
    dontUnpack = true;
    doCheck = true;
    nativeCheckInputs = [
      postgresqlTestHook
      (postgresql.withPackages (_: [ finalAttrs.finalPackage ]))
    ];
    failureHook = "postgresqlStop";
    postgresqlTestUserOptions = "LOGIN SUPERUSER";
    postgresqlExtraSettings = ''
      shared_preload_libraries=pgsodium
    '';
    passAsFile = [ "sql" ];
    sql = ''
      CREATE EXTENSION pgsodium;

      SELECT pgsodium.version();
      SELECT pgsodium.crypto_auth_keygen();
      SELECT pgsodium.randombytes_random() FROM generate_series(0, 5);
      SELECT * FROM pgsodium.crypto_box_new_keypair();
    '';
    checkPhase = ''
      runHook preCheck
      psql -a -v ON_ERROR_STOP=1 -f $sqlPath
      runHook postCheck
    '';
    installPhase = "touch $out";
  };

  meta = with lib; {
    description = "Modern cryptography for PostgreSQL using libsodium";
    homepage = "https://github.com/michelp/pgsodium";
    changelog = "https://github.com/michelp/pgsodium/releases/tag/v${finalAttrs.version}";
    license = licenses.postgresql;
    maintainers = [ ];
    platforms = postgresql.meta.platforms;
  };
})
