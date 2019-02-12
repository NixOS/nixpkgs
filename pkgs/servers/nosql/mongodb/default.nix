{ stdenv, fetchurl, fetchpatch, scons, boost, gperftools, pcre-cpp, snappy
, zlib, libyamlcpp, sasl, openssl, libpcap, Security
}:

# Note:
# The command line tools are written in Go as part of a different package (mongodb-tools)

with stdenv.lib;

let version = "3.4.10";
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

in stdenv.mkDerivation rec {
  name = "mongodb-${version}";

  src = fetchurl {
    url = "https://fastdl.mongodb.org/src/mongodb-src-r${version}.tar.gz";
    sha256 = "1wz2mhl9z0b1bdkg6m8v8mvw9k60mdv5ybq554xn3yjj9z500f24";
  };

  nativeBuildInputs = [ scons ];
  buildInputs = [
    sasl boost gperftools pcre-cpp snappy
    zlib libyamlcpp sasl openssl.dev openssl.out libpcap
  ] ++ stdenv.lib.optionals stdenv.isDarwin [ Security ];

  patches =
    [
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
  '';

  NIX_CFLAGS_COMPILE = stdenv.lib.optional stdenv.cc.isClang "-Wno-unused-command-line-argument";

  sconsFlags = [
    "--release"
    "--ssl"
    #"--rocksdb" # Don't have this packaged yet
    "--wiredtiger=${if stdenv.is64bit then "on" else "off"}"
    "--js-engine=mozjs"
    "--use-sasl-client"
    "--disable-warnings-as-errors"
    "VARIANT_DIR=nixos" # Needed so we don't produce argument lists that are too long for gcc / ld
  ] ++ map (lib: "--use-system-${lib}") system-libraries;

  preBuild = ''
    sconsFlags+=" CC=$CC"
    sconsFlags+=" CXX=$CXX"
  '';

  preInstall = ''
    mkdir -p $out/lib
  '';
  prefixKey = "--prefix=";

  enableParallelBuilding = true;

  hardeningEnable = [ "pie" ];

  meta = {
    description = "A scalable, high-performance, open source NoSQL database";
    homepage = http://www.mongodb.org;
    license = licenses.agpl3;

    maintainers = with maintainers; [ bluescreen303 offline cstrahan ];
    platforms = platforms.unix;
  };
}
