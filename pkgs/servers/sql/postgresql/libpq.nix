{
  # utils
  stdenv,
  fetchFromGitHub,
  lib,
  windows,

  # runtime dependencies
  openssl,
  tzdata,
  zlib,

  # build dependencies
  bison,
  flex,
  perl,
  pkg-config,

  # passthru / meta
  postgresql,
  buildPackages,

  # Curl
  curlSupport ?
    lib.meta.availableOn stdenv.hostPlatform curl
    # libpq's client-side OAuth support is not available on Windows/MinGW in upstream
    # configure logic (errors out during ./configure).
    && !stdenv.hostPlatform.isWindows
    # Building statically fails with:
    # configure: error: library 'curl' does not provide curl_multi_init
    # https://www.postgresql.org/message-id/487dacec-6d8d-46c0-a36f-d5b8c81a56f1%40technowledgy.de
    && !stdenv.hostPlatform.isStatic,
  curl,

  # GSSAPI
  gssSupport ? with stdenv.hostPlatform; !isWindows && !isStatic,
  libkrb5,

  # NLS
  nlsSupport ? false,
  gettext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libpq";
  version = "18.1";

  src = fetchFromGitHub {
    owner = "postgres";
    repo = "postgres";
    # rev, not tag, on purpose: see generic.nix.
    rev = "refs/tags/REL_18_1";
    hash = "sha256-cZA2hWtr5RwsUrRWkvl/yvUzFPSfdtpyAKGXfrVUr0g=";
  };

  __structuredAttrs = true;

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
  ++ lib.optionals stdenv.hostPlatform.isMinGW [ windows.pthreads ]
  ++ lib.optionals curlSupport [ curl ]
  ++ lib.optionals gssSupport [ libkrb5 ]
  ++ lib.optionals nlsSupport [ gettext ];

  nativeBuildInputs = [
    bison
    flex
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
  ++ lib.optionals curlSupport [ "--with-libcurl" ]
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
  ''
  + lib.optionalString curlSupport ''
    make -C src/interfaces/libpq-oauth install
  ''
  + ''
    make -C src/port install

    substituteInPlace src/common/pg_config.env \
      --replace-fail "$out" "@out@"

    install -D src/common/pg_config.env "$dev/nix-support/pg_config.env"
    # Keep MinGW import libraries (e.g. libpq.dll.a) in $out/lib so CMake find_library()
    # can locate them for consumers (Qt FindPostgreSQL.cmake). Move only "real" static libs.
    is_mingw=${if stdenv.hostPlatform.isMinGW then "1" else "0"}
    if [ -d "$out/lib" ]; then
      for a in "$out"/lib/*.a; do
        [ -e "$a" ] || continue
        case "$a" in
          *.dll.a) ;; # keep
          */libpq.a)
            # On MinGW the import library for libpq.dll is named libpq.a; keep it in $out/lib
            # so downstreams can locate it via CMake find_library().
            if [ "$is_mingw" = "1" ]; then
              :
            else
              moveToOutput "lib/$(basename "$a")" "$dev"
            fi
            ;;
          *) moveToOutput "lib/$(basename "$a")" "$dev" ;;
        esac
      done
    fi

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
      ;
    description = "C application programmer's interface to PostgreSQL";
    changelog = "https://www.postgresql.org/docs/release/${finalAttrs.version}/";
    pkgConfigModules = [ "libpq" ];
    # postgresql (server) is Unix-only in nixpkgs today, but libpq is a client library and
    # is available on Windows/MinGW (MSYS2 ships it). Enable libpq independently for Qt6
    platforms = postgresql.meta.platforms ++ lib.platforms.windows;
  };
})
