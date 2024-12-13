{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPackages,
  boost,
  gperftools,
  pcre2,
  pcre-cpp,
  snappy,
  zlib,
  yaml-cpp,
  sasl,
  net-snmp,
  openldap,
  openssl,
  libpcap,
  curl,
  Security,
  CoreFoundation,
  cctools,
  xz,
}:

# Note:
#   The command line administrative tools are part of other packages:
#   see pkgs.mongodb-tools and pkgs.mongosh.

{
  version,
  sha256,
  patches ? [ ],
  license ? lib.licenses.sspl,
  avxSupport ? stdenv.hostPlatform.avxSupport,
  passthru ? { },
}:

let
  scons = buildPackages.scons;
  python = scons.python.withPackages (
    ps: with ps; [
      pyyaml
      cheetah3
      psutil
      setuptools
      distutils
      packaging
      pymongo
    ]
  );

  system-libraries =
    [
      "boost"
      "snappy"
      "yaml"
      "zlib"
      #"asio" -- XXX use package?
      #"stemmer"  -- not nice to package yet (no versioning, no makefile, no shared libs).
      #"valgrind" -- mongodb only requires valgrind.h, which is vendored in the source.
      #"wiredtiger"
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ "tcmalloc" ]
    ++ lib.optionals (lib.versionOlder version "7.0") [
      "pcre"
    ]
    ++ lib.optionals (lib.versionAtLeast version "7.0") [
      "pcre2"
    ];
  inherit (lib) systems subtractLists;

in
stdenv.mkDerivation rec {
  inherit version passthru;
  pname = "mongodb";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "mongo";
    rev = "r${version}";
    inherit sha256;
  };

  nativeBuildInputs = [
    scons
    python
  ] ++ lib.optional stdenv.hostPlatform.isLinux net-snmp;

  buildInputs =
    [
      boost
      curl
      gperftools
      libpcap
      yaml-cpp
      openssl
      openldap
      pcre2
      pcre-cpp
      sasl
      snappy
      zlib
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      Security
      CoreFoundation
      cctools
    ]
    ++ lib.optional stdenv.hostPlatform.isLinux net-snmp
    ++ [ xz ];

  # MongoDB keeps track of its build parameters, which tricks nix into
  # keeping dependencies to build inputs in the final output.
  # We remove the build flags from buildInfo data.
  inherit patches;

  postPatch =
    ''
      # fix environment variable reading
      substituteInPlace SConstruct \
          --replace "env = Environment(" "env = Environment(ENV = os.environ,"
    ''
    + ''
      # Fix debug gcc 11 and clang 12 builds on Fedora
      # https://github.com/mongodb/mongo/commit/e78b2bf6eaa0c43bd76dbb841add167b443d2bb0.patch
      substituteInPlace src/mongo/db/query/plan_summary_stats.h --replace '#include <string>' '#include <optional>
      #include <string>'
      substituteInPlace src/mongo/db/exec/plan_stats.h --replace '#include <string>' '#include <optional>
      #include <string>'
    ''
    + lib.optionalString (!avxSupport) ''
      substituteInPlace SConstruct \
        --replace-fail "default=['+sandybridge']," 'default=[],'
    '';

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-unused-command-line-argument";

  sconsFlags = [
    "--release"
    "--ssl"
    #"--rocksdb" # Don't have this packaged yet
    "--wiredtiger=on"
    "--js-engine=mozjs"
    "--use-sasl-client"
    "--disable-warnings-as-errors"
    "VARIANT_DIR=nixos" # Needed so we don't produce argument lists that are too long for gcc / ld
    "--link-model=static"
    "MONGO_VERSION=${version}"
  ] ++ map (lib: "--use-system-${lib}") system-libraries;

  # This seems to fix mongodb not able to find OpenSSL's crypto.h during build
  hardeningDisable = [ "fortify3" ];

  preBuild =
    ''
      sconsFlags+=" CC=$CC"
      sconsFlags+=" CXX=$CXX"
    ''
    + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
      sconsFlags+=" AR=$AR"
    ''
    + lib.optionalString stdenv.hostPlatform.isAarch64 ''
      sconsFlags+=" CCFLAGS='-march=armv8-a+crc'"
    '';

  preInstall = ''
    mkdir -p "$out/lib"
  '';

  postInstall = ''
    rm -f "$out/bin/install_compass" || true
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    "$out/bin/mongo" --version
    runHook postInstallCheck
  '';

  installTargets = "install-devcore";

  prefixKey = "DESTDIR=";

  enableParallelBuilding = true;

  hardeningEnable = [ "pie" ];

  meta = with lib; {
    description = "Scalable, high-performance, open source NoSQL database";
    homepage = "http://www.mongodb.org";
    inherit license;

    maintainers = with maintainers; [
      bluescreen303
      offline
    ];
    platforms = subtractLists systems.doubles.i686 systems.doubles.unix;
  };
}
