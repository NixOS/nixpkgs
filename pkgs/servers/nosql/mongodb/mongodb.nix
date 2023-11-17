{ lib
, stdenv
, fetchurl
, scons_3_1_2
, boost
, gperftools
, pcre-cpp
, snappy
, zlib
, yaml-cpp
, sasl
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
  variants =
    if versionAtLeast version "6.0"
    then rec {
      python = scons.python.withPackages (ps: with ps; [
        pyyaml
        cheetah3
        psutil
        setuptools
        packaging
        pymongo
      ]);

      scons = scons_3_1_2;

      mozjsVersion = "60";
      mozjsReplace = "defined(HAVE___SINCOS)";

    }
    else rec {
      python = scons.python.withPackages (ps: with ps; [
        pyyaml
        cheetah3
        psutil
        setuptools
      ]);

      scons = scons_3_1_2;

      mozjsVersion = "60";
      mozjsReplace = "defined(HAVE___SINCOS)";

    };

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

  nativeBuildInputs = [ variants.scons ]
                      ++ lib.optionals (versionAtLeast version "4.4") [ xz ];

  buildInputs = [
    boost
    curl
    gperftools
    libpcap
    yaml-cpp
    openssl
    pcre-cpp
    variants.python
    sasl
    snappy
    zlib
  ] ++ lib.optionals stdenv.isDarwin [ Security CoreFoundation cctools ];

  # MongoDB keeps track of its build parameters, which tricks nix into
  # keeping dependencies to build inputs in the final output.
  # We remove the build flags from buildInfo data.
  inherit patches;

  postPatch = ''
    # fix environment variable reading
    substituteInPlace SConstruct \
        --replace "env = Environment(" "env = Environment(ENV = os.environ,"
   '' + lib.optionalString (versionAtLeast version "4.4") ''
    # Fix debug gcc 11 and clang 12 builds on Fedora
    # https://github.com/mongodb/mongo/commit/e78b2bf6eaa0c43bd76dbb841add167b443d2bb0.patch
    substituteInPlace src/mongo/db/query/plan_summary_stats.h --replace '#include <string>' '#include <optional>
    #include <string>'
    substituteInPlace src/mongo/db/exec/plan_stats.h --replace '#include <string>' '#include <optional>
    #include <string>'
  '' + lib.optionalString (versionOlder version "5.0") ''
    # remove -march overriding, we know better.
    sed -i 's/env.Append.*-march=.*$/pass/' SConstruct
  '' + lib.optionalString (stdenv.isDarwin && versionOlder version "6.0") ''
    substituteInPlace src/third_party/mozjs-${variants.mozjsVersion}/extract/js/src/jsmath.cpp --replace '${variants.mozjsReplace}' 0
  '' + lib.optionalString (stdenv.isDarwin && versionOlder version "3.6") ''
    substituteInPlace src/third_party/s2/s1angle.cc --replace drem remainder
    substituteInPlace src/third_party/s2/s1interval.cc --replace drem remainder
    substituteInPlace src/third_party/s2/s2cap.cc --replace drem remainder
    substituteInPlace src/third_party/s2/s2latlng.cc --replace drem remainder
    substituteInPlace src/third_party/s2/s2latlngrect.cc --replace drem remainder
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
  ] ++ lib.optionals (versionAtLeast version "4.4") [ "--link-model=static" ]
  ++ map (lib: "--use-system-${lib}") system-libraries;

  # This seems to fix mongodb not able to find OpenSSL's crypto.h during build
  hardeningDisable = [ "fortify3" ];

  preBuild = ''
    sconsFlags+=" CC=$CC"
    sconsFlags+=" CXX=$CXX"
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
    else if (versionAtLeast version "4.4") then "install-core"
    else "install";

  prefixKey = if (versionAtLeast version "4.4") then "DESTDIR=" else "--prefix=";

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
