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

  # GSSAPI
  gssSupport ? with stdenv.hostPlatform; !isWindows && !isStatic,
  libkrb5,

  # NLS
  nlsSupport ? false,
  gettext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libpq";
  version = "17.4";

  src = fetchFromGitHub {
    owner = "postgres";
    repo = "postgres";
    # rev, not tag, on purpose: see generic.nix.
    rev = "refs/tags/REL_17_4";
    hash = "sha256-TEpvX28chR3CXiOQsNY12t8WfM9ywoZVX1e/6mj9DqE=";
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
    ] ++ (map lib.getDev (builtins.filter (drv: drv ? "dev") finalAttrs.buildInputs));
  };

  buildInputs =
    [
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

  configureFlags =
    [
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

  installPhase = ''
    runHook preInstall

    make -C src/bin/pg_config install
    make -C src/common install
    make -C src/include install
    make -C src/interfaces/libpq install
    make -C src/port install

    # Pretend pg_config is located in $out/bin to return correct paths, but
    # actually have it in -dev to avoid pulling in all other outputs.
    moveToOutput bin/pg_config "$dev"
    wrapProgram "$dev/bin/pg_config" --argv0 "$out/bin/pg_config"

    # To prevent a "pg_config: could not find own program executable" error, we fake
    # pg_config in the default output.
    mkdir -p "$out/bin"
    cat << EOF > "$out/bin/pg_config" && chmod +x "$out/bin/pg_config"
    #!${stdenv.shell}
    echo The real pg_config can be found in the -dev output.
    exit 1
    EOF

    moveToOutput "lib/*.a" "$dev"

    rm -rfv $out/share
    rm -rfv $dev/lib/*_shlib.a

    runHook postInstall
  '';

  # PostgreSQL always builds both shared and static libs, so we delete those we don't want.
  postInstall =
    if stdenv.hostPlatform.isStatic then
      ''
        rm -rfv $out/lib/*.so*
        touch $out/empty
      ''
    else
      "rm -rfv $dev/lib/*.a";

  doCheck = false;

  meta = {
    inherit (postgresql.meta)
      homepage
      license
      maintainers
      platforms
      ;
    description = "C application programmer's interface to PostgreSQL";
    changelog = "https://www.postgresql.org/docs/release/${finalAttrs.version}/";
    pkgConfigModules = [ "libpq" ];
  };
})
