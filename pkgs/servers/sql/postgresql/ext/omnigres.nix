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
  unstableGitUpdater,
}:

let
  pgWithExtensions = postgresql.withPackages (ps: [ ps.plpython3 ]);
in
postgresqlBuildExtension (finalAttrs: {
  pname = "omnigres";
  version = "0-unstable-2025-06-27";

  src = fetchFromGitHub {
    owner = "omnigres";
    repo = "omnigres";
    rev = "f1b35e623b2583d1124c593f0d9c8466d8fa3a56";
    hash = "sha256-FiZuXvY+1qyLTnxZ9Y5MP9SxM4wncX4L4rDJEa6O7NE=";
  };

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
    "-DPostgreSQL_EXTENSION_DIR=${pgWithExtensions}/share/postgresql/extension/"
    "-DPostgreSQL_PACKAGE_LIBRARY_DIR=${pgWithExtensions}/lib/"
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
