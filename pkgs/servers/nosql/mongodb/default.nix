{ stdenv, fetchurl, fetchpatch, scons, boost, gperftools, pcre-cpp, snappy
, zlib, libyamlcpp, sasl, openssl, libpcap, wiredtiger, Security
}:

# Note:
# The command line tools are written in Go as part of a different package (mongodb-tools)

with stdenv.lib;

let version = "3.2.9";
    system-libraries = [
      "pcre"
      #"asio" -- XXX use package?
      #"wiredtiger"
      "boost"
      "snappy"
      "zlib"
      #"valgrind" -- mongodb only requires valgrind.h, which is vendored in the source.
      #"stemmer"  -- not nice to package yet (no versioning, no makefile, no shared libs).
      "yaml"
    ] ++ optionals stdenv.isLinux [ "tcmalloc" ];

    buildInputs = [
      sasl boost gperftools pcre-cpp snappy
      zlib libyamlcpp sasl openssl.dev openssl.out libpcap
    ] ++ stdenv.lib.optionals stdenv.isDarwin [ Security ];

    other-args = concatStringsSep " " ([
      "--ssl"
      #"--rocksdb" # Don't have this packaged yet
      "--wiredtiger=${if stdenv.is64bit then "on" else "off"}"
      "--js-engine=mozjs"
      "--use-sasl-client"
      "--disable-warnings-as-errors"
      "VARIANT_DIR=nixos" # Needed so we don't produce argument lists that are too long for gcc / ld
      "CC=$CC"
      "CXX=$CXX"
      "CCFLAGS=\"${concatStringsSep " " (map (input: "-I${input}/include") buildInputs)}\""
      "LINKFLAGS=\"${concatStringsSep " " (map (input: "-L${input}/lib") buildInputs)}\""
    ] ++ map (lib: "--use-system-${lib}") system-libraries);

in stdenv.mkDerivation rec {
  name = "mongodb-${version}";

  src = fetchurl {
    url = "http://downloads.mongodb.org/src/mongodb-src-r${version}.tar.gz";
    sha256 = "06q6j2bjy31pjwqws53wdpmn2x8w2hafzsnv1s3wx15pc9vq3y15";
  };

  nativeBuildInputs = [ scons ];
  inherit buildInputs;

  patches =
    [
      # When not building with the system valgrind, the build should use the
      # vendored header file - regardless of whether or not we're using the system
      # tcmalloc - so we need to lift the include path manipulation out of the
      # conditional.
      ./valgrind-include.patch

      # MongoDB keeps track of its build parameters, which tricks nix into
      # keeping dependencies to build inputs in the final output.
      # We remove the build flags from buildInfo data.
      ./forget-build-dependencies.patch
      (fetchpatch {
        url = https://projects.archlinux.org/svntogit/community.git/plain/trunk/boost160.patch?h=packages/mongodb;
        name = "boost160.patch";
        sha256 = "0bvsf3499zj55pzamwjmsssr6x63w434944w76273fr5rxwzcmh8";
      })
    ];

  postPatch = ''
    # fix environment variable reading
    substituteInPlace SConstruct \
        --replace "env = Environment(" "env = Environment(ENV = os.environ,"
  '' + stdenv.lib.optionalString stdenv.isDarwin ''

    substituteInPlace src/third_party/s2/s1angle.cc --replace drem remainder
    substituteInPlace src/third_party/s2/s1interval.cc --replace drem remainder
    substituteInPlace src/third_party/s2/s2cap.cc --replace drem remainder
    substituteInPlace src/third_party/s2/s2latlng.cc --replace drem remainder
    substituteInPlace src/third_party/s2/s2latlngrect.cc --replace drem remainder
  '' + stdenv.lib.optionalString stdenv.isi686 ''

    # don't fail by default on i686
    substituteInPlace src/mongo/db/storage/storage_options.h \
      --replace 'engine("wiredTiger")' 'engine("mmapv1")'
  ''
    # pcrecpp.h used to export some "using std::foo;" directives before 8.41,
    # therefore adding them next to the include should be safe.
    # Upstream patch for 3.2 branch apparently doesn't work for our 3.2.9
    # https://github.com/mongodb/mongo/commit/18f4c63869a3
  + ''
    sed '/^#include <pcrecpp\.h>/i using std::string;' \
      -i src/mongo/util/version.cpp.in \
      -i src/mongo/util/options_parser/constraints.cpp \
      -i src/mongo/util/net/miniwebserver.cpp \
      -i src/mongo/shell/dbshell.cpp \
      -i src/mongo/shell/bench.cpp \
      -i src/mongo/s/catalog/replset/catalog_manager_replica_set_test.cpp \
      -i src/mongo/s/catalog/replset/catalog_manager_replica_set.cpp \
      -i src/mongo/s/catalog/legacy/catalog_manager_legacy.cpp \
      -i src/mongo/db/repl/master_slave.cpp \
      -i src/mongo/db/matcher/expression_leaf.cpp \
      -i src/mongo/db/dbwebserver.cpp
  '';

  NIX_CFLAGS_COMPILE = stdenv.lib.optional stdenv.cc.isClang "-Wno-unused-command-line-argument";

  buildPhase = ''
    scons -j $NIX_BUILD_CORES core --release ${other-args}
  '';

  installPhase = ''
    mkdir -p $out/lib
    scons -j $NIX_BUILD_CORES install --release --prefix=$out ${other-args}
  '';

  enableParallelBuilding = true;

  hardeningEnable = [ "pie" ];

  meta = {
    description = "A scalable, high-performance, open source NoSQL database";
    homepage = http://www.mongodb.org;
    license = licenses.agpl3;

    maintainers = with maintainers; [ bluescreen303 offline wkennington cstrahan ];
    platforms = platforms.unix;
  };
}
