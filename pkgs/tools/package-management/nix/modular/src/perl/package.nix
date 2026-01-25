{
  lib,
  stdenv,
  mkMesonDerivation,
  pkg-config,
  perl,
  perlPackages,
  nix-store,
  version,
  curl,
  bzip2,
  libsodium,
}:

perl.pkgs.toPerlModule (
  mkMesonDerivation (finalAttrs: {
    pname = "nix-perl";
    inherit version;

    workDir = ./.;

    nativeBuildInputs = [
      pkg-config
      perl
      curl
    ];

    buildInputs = [
      nix-store
      bzip2
      libsodium
    ]
    ++ lib.optional stdenv.hostPlatform.isCygwin perl;

    env = lib.optionalAttrs stdenv.hostPlatform.isCygwin {
      NIX_CFLAGS_COMPILE = toString (
        lib.optionals stdenv.hostPlatform.isCygwin [
          # longjmp, siginfo_t
          "-D_POSIX_C_SOURCE=199309L"
          # putenv
          "-D_XOPEN_SOURCE"
        ]
      );
    };

    # `perlPackages.Test2Harness` is marked broken for Darwin
    doCheck = !stdenv.isDarwin;

    nativeCheckInputs = [
      perlPackages.Test2Harness
    ];

    preConfigure =
      # "Inline" .version so its not a symlink, and includes the suffix
      ''
        chmod u+w .version
        echo ${finalAttrs.version} > .version
      '';

    mesonFlags = [
      (lib.mesonOption "dbi_path" "${perlPackages.DBI}/${perl.libPrefix}")
      (lib.mesonOption "dbd_sqlite_path" "${perlPackages.DBDSQLite}/${perl.libPrefix}")
      (lib.mesonEnable "tests" finalAttrs.finalPackage.doCheck)
    ];

    mesonCheckFlags = [
      "--print-errorlogs"
    ];

    strictDeps = false;
  })
)
