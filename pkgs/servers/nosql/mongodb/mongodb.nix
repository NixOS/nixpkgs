{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPackages,
  boost,
  gperftools,
  snappy,
  zlib,
  yaml-cpp,
  sasl,
  net-snmp,
  openldap,
  openssl,
  libpcap,
  curl,
  cctools,
  xz,
<<<<<<< HEAD
  versionCheckHook,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

# Note:
#   The command line administrative tools are part of other packages:
#   see pkgs.mongodb-tools and pkgs.mongosh.

{
  version,
<<<<<<< HEAD
  hash,
=======
  sha256,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

  system-libraries = [
    "boost"
    #pcre2 -- breaks on pcre2-10.46 with at least version 7.0.24
    "snappy"
    "yaml"
    "zlib"
    #"asio" -- XXX use package?
    #"stemmer"  -- not nice to package yet (no versioning, no makefile, no shared libs).
    #"valgrind" -- mongodb only requires valgrind.h, which is vendored in the source.
    #"wiredtiger"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ "tcmalloc" ];
  inherit (lib) systems subtractLists;

in
<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
=======
stdenv.mkDerivation rec {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  inherit version passthru;
  pname = "mongodb";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "mongo";
<<<<<<< HEAD
    tag = "r${finalAttrs.version}";
    inherit hash;
=======
    rev = "r${version}";
    inherit sha256;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    scons
    python
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux net-snmp;

  buildInputs = [
    boost
    curl
    gperftools
    libpcap
    yaml-cpp
    openssl
    openldap
    sasl
    snappy
<<<<<<< HEAD
    xz
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cctools
  ]
<<<<<<< HEAD
  ++ lib.optional stdenv.hostPlatform.isLinux net-snmp;
=======
  ++ lib.optional stdenv.hostPlatform.isLinux net-snmp
  ++ [ xz ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # MongoDB keeps track of its build parameters, which tricks nix into
  # keeping dependencies to build inputs in the final output.
  # We remove the build flags from buildInfo data.
  inherit patches;

  postPatch = ''
    # fix environment variable reading
    substituteInPlace SConstruct \
<<<<<<< HEAD
        --replace-fail "env = Environment(" "env = Environment(ENV = os.environ,"
=======
        --replace "env = Environment(" "env = Environment(ENV = os.environ,"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ''
  + ''
    # Fix debug gcc 11 and clang 12 builds on Fedora
    # https://github.com/mongodb/mongo/commit/e78b2bf6eaa0c43bd76dbb841add167b443d2bb0.patch
<<<<<<< HEAD
    substituteInPlace src/mongo/db/query/plan_summary_stats.h --replace-fail '#include <string>' '#include <optional>
    #include <string>'
    substituteInPlace src/mongo/db/exec/plan_stats.h --replace-fail '#include <string>' '#include <optional>
=======
    substituteInPlace src/mongo/db/query/plan_summary_stats.h --replace '#include <string>' '#include <optional>
    #include <string>'
    substituteInPlace src/mongo/db/exec/plan_stats.h --replace '#include <string>' '#include <optional>
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    "MONGO_VERSION=${finalAttrs.version}"
=======
    "MONGO_VERSION=${version}"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ]
  ++ map (lib: "--use-system-${lib}") system-libraries;

  # This seems to fix mongodb not able to find OpenSSL's crypto.h during build
  hardeningDisable = [ "fortify3" ];

  preBuild = ''
    appendToVar sconsFlags "CC=$CC"
    appendToVar sconsFlags "CXX=$CXX"
  ''
  + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    appendToVar sconsFlags "AR=$AR"
  ''
  + lib.optionalString stdenv.hostPlatform.isAarch64 ''
    appendToVar sconsFlags "CCFLAGS=-march=armv8-a+crc"
  '';

  preInstall = ''
    mkdir -p "$out/lib"
  '';

  postInstall = ''
    rm -f "$out/bin/install_compass" || true
  '';

  doInstallCheck = true;
<<<<<<< HEAD
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/mongo";
  versionCheckProgramArg = "--version";
=======
  installCheckPhase = ''
    runHook preInstallCheck
    "$out/bin/mongo" --version
    runHook postInstallCheck
  '';
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  installTargets = "install-devcore";

  prefixKey = "DESTDIR=";

  enableParallelBuilding = true;

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Scalable, high-performance, open source NoSQL database";
    homepage = "http://www.mongodb.org";
    inherit license;

<<<<<<< HEAD
    maintainers = with lib.maintainers; [
=======
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      offline
    ];
    platforms = subtractLists systems.doubles.i686 systems.doubles.unix;
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
