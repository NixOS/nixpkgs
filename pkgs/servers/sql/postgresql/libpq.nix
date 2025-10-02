{
  # utils
  stdenv,
  fetchFromGitHub,
  lib,

  # runtime dependencies
  openssl,
  tzdata,
  zlib,

  # build dependencies
  bison,
  flex,
  makeWrapper,
  perl,
  pkg-config,

  # passthru / meta
  postgresql,
  buildPackages,

  # GSSAPI
  gssSupport ? with stdenv.hostPlatform; !isWindows && !isStatic,
  libkrb5,

  # NLS
  nlsSupport ? false,
  gettext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libpq";
  version = "17.6";

  src = fetchFromGitHub {
    owner = "postgres";
    repo = "postgres";
    # rev, not tag, on purpose: see generic.nix.
    rev = "refs/tags/REL_17_6";
    hash = "sha256-/7C+bjmiJ0/CvoAc8vzTC50vP7OsrM6o0w+lmmHvKvU=";
  };

  __structuredAttrs = true;

  hardeningEnable = lib.optionals (!stdenv.cc.isClang) [ "pie" ];

  outputs = [
    "out"
    "dev"
  ];
  outputChecks.out = {
    disallowedReferences = [ "dev" ];
    disallowedRequisites = [
      stdenv.cc
    ]
    ++ (map lib.getDev (builtins.filter (drv: drv ? "dev") finalAttrs.buildInputs));
  };

  buildInputs = [
    zlib
    openssl
  ]
  ++ lib.optionals gssSupport [ libkrb5 ]
  ++ lib.optionals nlsSupport [ gettext ];

  nativeBuildInputs = [
    bison
    flex
    makeWrapper
    perl
    pkg-config
  ];

  # causes random build failures
  enableParallelBuilding = false;

  separateDebugInfo = true;

  buildFlags = [
    "submake-libpgport"
    "submake-libpq"
  ];

  # libpgcommon.a and libpgport.a contain all paths normally returned by pg_config and are
  # linked into all shared libraries. However, almost no binaries actually use those paths.
  # The following flags will remove unused sections from all shared libraries - including
  # those paths. This avoids a lot of circular dependency problems with different outputs,
  # and allows splitting them cleanly.
  env.CFLAGS =
    "-fdata-sections -ffunction-sections"
    + (if stdenv.cc.isClang then " -flto" else " -fmerge-constants -Wl,--gc-sections");

  # This flag was introduced upstream in:
  # https://github.com/postgres/postgres/commit/b6c7cfac88c47a9194d76f3d074129da3c46545a
  # It causes errors when linking against libpq.a in pkgsStatic:
  #   undefined reference to `pg_encoding_to_char'
  # Unsetting the flag fixes it. The upstream reasoning to introduce it is about the risk
  # to have initdb load a libpq.so from a different major version and how to avoid that.
  # This doesn't apply to us with Nix.
  env.NIX_CFLAGS_COMPILE = "-UUSE_PRIVATE_ENCODING_FUNCS";

  configureFlags = [
    "--enable-debug"
    "--sysconfdir=/etc"
    "--with-openssl"
    "--with-system-tzdata=${tzdata}/share/zoneinfo"
    "--without-icu"
    "--without-perl"
    "--without-readline"
  ]
  ++ lib.optionals gssSupport [ "--with-gssapi" ]
  ++ lib.optionals nlsSupport [ "--enable-nls" ];

  patches = lib.optionals stdenv.hostPlatform.isLinux [
    ./patches/socketdir-in-run-13+.patch
  ];

  postPatch = ''
    cat ${./pg_config.env.mk} >> src/common/Makefile
  ''
  # Explicitly disable building the shared libs, because that would fail with pkgsStatic.
  + lib.optionalString stdenv.hostPlatform.isStatic ''
    substituteInPlace src/interfaces/libpq/Makefile \
      --replace-fail "all: all-lib libpq-refs-stamp" "all: all-lib"
    substituteInPlace src/Makefile.shlib \
      --replace-fail "all-lib: all-shared-lib" "all-lib: all-static-lib" \
      --replace-fail "install-lib: install-lib-shared" "install-lib: install-lib-static"
  '';

  installPhase = ''
    runHook preInstall

    make -C src/common install pg_config.env
    make -C src/include install
    make -C src/interfaces/libpq install
    make -C src/port install

    substituteInPlace src/common/pg_config.env \
      --replace-fail "$out" "@out@"

    install -D src/common/pg_config.env "$dev/nix-support/pg_config.env"
    moveToOutput "lib/*.a" "$dev"

    rm -rfv $out/share
    rm -rfv $dev/lib/*_shlib.a

    runHook postInstall
  '';

  # PostgreSQL always builds both shared and static libs, so we delete those we don't want.
  postInstall = if stdenv.hostPlatform.isStatic then "touch $out/empty" else "rm -rfv $dev/lib/*.a";

  doCheck = false;

  passthru.pg_config = buildPackages.callPackage ./pg_config.nix {
    inherit (finalAttrs) finalPackage;
    outputs = {
      out = lib.getOutput "out" finalAttrs.finalPackage;
    };
  };

  meta = {
    inherit (postgresql.meta)
      homepage
      license
      teams
      platforms
      ;
    description = "C application programmer's interface to PostgreSQL";
    changelog = "https://www.postgresql.org/docs/release/${finalAttrs.version}/";
    pkgConfigModules = [ "libpq" ];
  };
})
