{
  brotli,
  clang_18,
  cmake,
  fetchFromGitHub,
  flex,
  lib,
  netcat,
  perl,
  pkg-config,
  postgresql,
  postgresqlBuildExtension,
  postgresqlTestExtension,
  python3,
  stdenv,
  unstableGitUpdater,
}:

let
  pgWithExtensions = postgresql.withPackages (ps: [ ps.plpython3 ]);
in
postgresqlBuildExtension (finalAttrs: {
  pname = "omnigres";
  version = "0-unstable-2025-09-05";

  src = fetchFromGitHub {
    owner = "omnigres";
    repo = "omnigres";
    rev = "f9ec95c59a786835f38629a2e04a4784a460fba1";
    hash = "sha256-F1vG+iAlixdWwW3LIovzwnuL75QTCDlF40QOUD5dNZk=";
  };

  # This matches postInstall of PostgreSQL's generic.nix, which does this for the PGXS Makefile.
  # Since omnigres uses a CMake file, which tries to replicate the things that PGXS does, we need
  # to apply the same fix for darwin.
  # The reason we need to do this is, because PG_BINARY will point at the postgres wrapper of
  # postgresql.withPackages, which does not contain the same symbols as the original file, ofc.
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace "cmake/PostgreSQLExtension.cmake" \
      --replace-fail '-bundle_loader ''${PG_BINARY}' "-bundle_loader ${postgresql}/bin/postgres"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    clang_18
    cmake
    flex
    netcat
    pkg-config
    perl
    python3
  ];

  buildInputs = postgresql.buildInputs ++ [
    brotli
  ];

  cmakeFlags = [
    "-DOPENSSL_CONFIGURED=1"
    "-DPG_CONFIG=${pgWithExtensions.pg_config}/bin/pg_config"
    "-DPostgreSQL_TARGET_EXTENSION_DIR=${builtins.placeholder "out"}/share/postgresql/extension/"
    "-DPostgreSQL_TARGET_PACKAGE_LIBRARY_DIR=${builtins.placeholder "out"}/lib/"
  ];

  enableParallelBuilding = true;
  doCheck = false;

  preInstall = ''
    patchShebangs script_omni*
    mkdir -p $out/lib/
    mkdir -p $out/share/postgresql/extension/
  '';

  # https://github.com/omnigres/omnigres?tab=readme-ov-file#building--using-extensions
  installTargets = [ "install_extensions" ];

  passthru.tests.extension = postgresqlTestExtension {
    inherit (finalAttrs) finalPackage;
    sql = ''
      -- https://docs.omnigres.org/omni_id/identity_type/#usage
      CREATE EXTENSION omni_id;

      SELECT identity_type('user_id');
    '';
  };

  passthru.updateScript = unstableGitUpdater {
    hardcodeZeroVersion = true;
  };

  meta = {
    description = "Postgres as a Business Operating System";
    homepage = "https://docs.omnigres.org";
    maintainers = with lib.maintainers; [ mtrsk ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.asl20;
    broken = lib.versionOlder postgresql.version "14";
  };
})
