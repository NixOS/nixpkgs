{ lib
, stdenv
, fetchurl
, buildPackages
, boost
, gperftools
, pcre-cpp
, snappy
, zlib
, yaml-cpp
, sasl
, net-snmp
, openldap
, openssl
, libpcap
, python3
, curl
, Security
, CoreFoundation
, cctools
, xz
}:

# Note:
#   The command line administrative tools are part of other packages:
#   see pkgs.mongodb-tools and pkgs.mongosh.

with lib;

{ version, sha256, patches ? []
, license ? lib.licenses.sspl
}:

let
  scons = buildPackages.scons;
  python = scons.python.withPackages (ps: with ps; [
    pyyaml
    cheetah3
    psutil
    setuptools
  ] ++ lib.optionals (versionAtLeast version "6.0") [
    packaging
    pymongo
  ]);

  mozjsVersion = "60";
  mozjsReplace = "defined(HAVE___SINCOS)";

  system-libraries = [
    "boost"
    "pcre"
    "snappy"
    "yaml"
    "zlib"
    #"asio" -- XXX use package?
    #"stemmer"  -- not nice to package yet (no versioning, no makefile, no shared libs).
    #"valgrind" -- mongodb only requires valgrind.h, which is vendored in the source.
    #"wiredtiger"
  ] ++ optionals stdenv.isLinux [ "tcmalloc" ];
  inherit (lib) systems subtractLists;

in stdenv.mkDerivation rec {
  inherit version;
  pname = "mongodb";

  src = fetchurl {
    url = "https://fastdl.mongodb.org/src/mongodb-src-r${version}.tar.gz";
    inherit sha256;
  };

  nativeBuildInputs = [
    scons
    python
  ] ++ lib.optional stdenv.isLinux net-snmp;

  buildInputs = [
    boost
    curl
    gperftools
    libpcap
    yaml-cpp
    openssl
    openldap
    pcre-cpp
    sasl
    snappy
    zlib
  ] ++ lib.optionals stdenv.isDarwin [ Security CoreFoundation cctools ]
  ++ lib.optional stdenv.isLinux net-snmp
  ++ [ xz ];

  # MongoDB keeps track of its build parameters, which tricks nix into
  # keeping dependencies to build inputs in the final output.
  # We remove the build flags from buildInfo data.
  inherit patches;

  postPatch = ''
    # fix environment variable reading
    substituteInPlace SConstruct \
        --replace "env = Environment(" "env = Environment(ENV = os.environ,"
   '' + ''
    # Fix debug gcc 11 and clang 12 builds on Fedora
    # https://github.com/mongodb/mongo/commit/e78b2bf6eaa0c43bd76dbb841add167b443d2bb0.patch
    substituteInPlace src/mongo/db/query/plan_summary_stats.h --replace '#include <string>' '#include <optional>
    #include <string>'
    substituteInPlace src/mongo/db/exec/plan_stats.h --replace '#include <string>' '#include <optional>
    #include <string>'
  '' + lib.optionalString (stdenv.isDarwin && versionOlder version "6.0") ''
    substituteInPlace src/third_party/mozjs-${mozjsVersion}/extract/js/src/jsmath.cpp --replace '${mozjsReplace}' 0
  '' + lib.optionalString stdenv.isi686 ''

    # don't fail by default on i686
    substituteInPlace src/mongo/db/storage/storage_options.h \
      --replace 'engine("wiredTiger")' 'engine("mmapv1")'
  '';

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang
    "-Wno-unused-command-line-argument";

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
  ]
  ++ map (lib: "--use-system-${lib}") system-libraries;

  # This seems to fix mongodb not able to find OpenSSL's crypto.h during build
  hardeningDisable = [ "fortify3" ];

  preBuild = ''
    sconsFlags+=" CC=$CC"
    sconsFlags+=" CXX=$CXX"
  '' + optionalString (!stdenv.isDarwin) ''
    sconsFlags+=" AR=$AR"
  '' + optionalString stdenv.isAarch64 ''
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

  installTargets =
    if (versionAtLeast version "6.0") then "install-devcore"
    else "install-core";

  prefixKey = "DESTDIR=";

  enableParallelBuilding = true;

  hardeningEnable = [ "pie" ];

  meta = {
    description = "A scalable, high-performance, open source NoSQL database";
    homepage = "http://www.mongodb.org";
    inherit license;

    maintainers = with maintainers; [ bluescreen303 offline ];
    platforms = subtractLists systems.doubles.i686 systems.doubles.unix;
    broken = (versionOlder version "6.0" && stdenv.system == "aarch64-darwin");
  };
}
