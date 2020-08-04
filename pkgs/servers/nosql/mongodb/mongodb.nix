{ stdenv, fetchurl, sconsPackages, boost, gperftools, pcre-cpp, snappy, zlib, libyamlcpp
, sasl, openssl, libpcap, python27, python38, curl, Security, CoreFoundation, cctools }:

# Note:
# The command line tools are written in Go as part of a different package (mongodb-tools)

with stdenv.lib;

{ version, sha256, patches ? []
, license ? stdenv.lib.licenses.sspl
}@args:

let
  variants = if versionAtLeast version "4.2"
    then { python = python38.withPackages (ps: with ps; [ pyyaml cheetah3 psutil setuptools ]);
            scons = sconsPackages.scons_latest;
            mozjsVersion = "60";
            mozjsReplace = "defined(HAVE___SINCOS)";
          }
    else { python = python27.withPackages (ps: with ps; [ pyyaml typing cheetah ]);
            scons = sconsPackages.scons_3_1_2;
            mozjsVersion = "45";
            mozjsReplace = "defined(HAVE_SINCOS)";
          };
  python = python27.withPackages (ps: with ps; [ pyyaml typing cheetah ]);
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
  inherit (stdenv.lib) systems subtractLists;

in stdenv.mkDerivation rec {
  inherit version;
  pname = "mongodb";

  src = fetchurl {
    url = "https://fastdl.mongodb.org/src/mongodb-src-r${version}.tar.gz";
    inherit sha256;
  };

  nativeBuildInputs = [ variants.scons ];
  buildInputs = [
    boost
    curl
    gperftools
    libpcap
    libyamlcpp
    openssl
    pcre-cpp
    variants.python
    sasl
    snappy
    zlib
  ] ++ stdenv.lib.optionals stdenv.isDarwin [ Security CoreFoundation cctools ];

  # MongoDB keeps track of its build parameters, which tricks nix into
  # keeping dependencies to build inputs in the final output.
  # We remove the build flags from buildInfo data.
  inherit patches;

  postPatch = ''
    # fix environment variable reading
    substituteInPlace SConstruct \
        --replace "env = Environment(" "env = Environment(ENV = os.environ,"
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace src/third_party/mozjs-${variants.mozjsVersion}/extract/js/src/jsmath.cpp --replace '${variants.mozjsReplace}' 0

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

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.cc.isClang
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
  ] ++ map (lib: "--use-system-${lib}") system-libraries;

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

  prefixKey = "--prefix=";

  enableParallelBuilding = true;

  hardeningEnable = [ "pie" ];

  meta = {
    description = "A scalable, high-performance, open source NoSQL database";
    homepage = "http://www.mongodb.org";
    inherit license;

    maintainers = with maintainers; [ bluescreen303 offline cstrahan ];
    platforms = subtractLists systems.doubles.i686 systems.doubles.unix;
  };
}
