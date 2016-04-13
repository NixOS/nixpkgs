{ stdenv, ensureNewerSourcesHook, autoconf, automake, makeWrapper, pkgconfig
, libtool, which, git
, boost, python, pythonPackages, libxml2, zlib

# Optional Dependencies
, snappy ? null, leveldb ? null, yasm ? null, fcgi ? null, expat ? null
, curl ? null, fuse ? null, accelio ? null, libibverbs ? null, librdmacm ? null
, libedit ? null, libatomic_ops ? null, kinetic-cpp-client ? null
, rocksdb ? null, libs3 ? null

# Mallocs
, jemalloc ? null, gperftools ? null

# Crypto Dependencies
, cryptopp ? null
, nss ? null, nspr ? null

# Linux Only Dependencies
, linuxHeaders, libuuid, udev, keyutils, libaio ? null, libxfs ? null
, zfs ? null

# Version specific arguments
, version, src, patches ? [], buildInputs ? []
, ...
}:

# We must have one crypto library
assert cryptopp != null || (nss != null && nspr != null);

with stdenv;
with stdenv.lib;
let
  mkFlag = trueStr: falseStr: cond: name: val:
    if cond == null then null else
      "--${if cond != false then trueStr else falseStr}${name}"
      + "${if val != null && cond != false then "=${val}" else ""}";

  mkEnable = mkFlag "enable-" "disable-";
  mkWith = mkFlag "with-" "without-";
  mkOther = mkFlag "" "" true;

  shouldUsePkg = pkg_: let pkg = (builtins.tryEval pkg_).value;
    in if lib.any (x: x == system) (pkg.meta.platforms or [])
      then pkg else null;

  optSnappy = shouldUsePkg snappy;
  optLeveldb = shouldUsePkg leveldb;
  optYasm = shouldUsePkg yasm;
  optFcgi = shouldUsePkg fcgi;
  optExpat = shouldUsePkg expat;
  optCurl = shouldUsePkg curl;
  optFuse = shouldUsePkg fuse;
  optAccelio = shouldUsePkg accelio;
  optLibibverbs = shouldUsePkg libibverbs;
  optLibrdmacm = shouldUsePkg librdmacm;
  optLibedit = shouldUsePkg libedit;
  optLibatomic_ops = shouldUsePkg libatomic_ops;
  optKinetic-cpp-client = shouldUsePkg kinetic-cpp-client;
  optRocksdb = shouldUsePkg rocksdb;
  optLibs3 = if versionAtLeast version "10.0.0" then null else shouldUsePkg libs3;

  optJemalloc = shouldUsePkg jemalloc;
  optGperftools = shouldUsePkg gperftools;

  optCryptopp = shouldUsePkg cryptopp;
  optNss = shouldUsePkg nss;
  optNspr = shouldUsePkg nspr;

  optLibaio = shouldUsePkg libaio;
  optLibxfs = shouldUsePkg libxfs;
  optZfs = shouldUsePkg zfs;

  hasServer = optSnappy != null && optLeveldb != null;
  hasMon = hasServer;
  hasMds = hasServer;
  hasOsd = hasServer;
  hasRadosgw = optFcgi != null && optExpat != null && optCurl != null && optLibedit != null;

  hasXio = (stdenv.isLinux || stdenv.isFreeBSD) &&
    versionAtLeast version "9.0.3" &&
    optAccelio != null && optLibibverbs != null && optLibrdmacm != null;

  hasRocksdb = versionAtLeast version "9.0.0" && optRocksdb != null;

  # TODO: Reenable when kinetic support is fixed
  #hasKinetic = versionAtLeast version "9.0.0" && optKinetic-cpp-client != null;
  hasKinetic = false;

  # Malloc implementation (can be jemalloc, tcmalloc or null)
  malloc = if optJemalloc != null then optJemalloc else optGperftools;

  # We prefer nss over cryptopp
  cryptoStr = if optNss != null && optNspr != null then "nss" else
    if optCryptopp != null then "cryptopp" else "none";
  cryptoLibsMap = {
    nss = [ optNss optNspr ];
    cryptopp = [ optCryptopp ];
    none = [ ];
  };

  wrapArgs = "--set PYTHONPATH \"$(toPythonPath $lib)\""
    + " --prefix PYTHONPATH : \"$(toPythonPath ${python.modules.readline})\""
    + " --prefix PYTHONPATH : \"$(toPythonPath ${pythonPackages.flask})\""
    + " --set PATH \"$out/bin\"";
in
stdenv.mkDerivation {
  name="ceph-${version}";

  inherit src;

  patches = patches ++ [
    ./0001-Makefile-env-Don-t-force-sbin.patch
  ];

  nativeBuildInputs = [
    autoconf automake makeWrapper pkgconfig libtool which git
    (ensureNewerSourcesHook { year = "1980"; })
  ]
    ++ optionals (versionAtLeast version "9.0.2") [
      pythonPackages.setuptools pythonPackages.argparse
    ];
  buildInputs = buildInputs ++ cryptoLibsMap.${cryptoStr} ++ [
    boost python libxml2 optYasm optLibatomic_ops optLibs3 malloc pythonPackages.flask zlib
  ] ++ optional (versionAtLeast version "9.0.0") [
    pythonPackages.sphinx # Used for docs
  ] ++ optional stdenv.isLinux [
    linuxHeaders libuuid udev keyutils optLibaio optLibxfs optZfs
  ] ++ optional hasServer [
    optSnappy optLeveldb
  ] ++ optional hasRadosgw [
    optFcgi optExpat optCurl optFuse optLibedit
  ] ++ optional hasXio [
    optAccelio optLibibverbs optLibrdmacm
  ] ++ optional hasRocksdb [
    optRocksdb
  ] ++ optional hasKinetic [
    optKinetic-cpp-client
  ];

  postPatch = ''
    # Fix zfs pkgconfig detection
    sed -i 's,\[zfs\],\[libzfs\],g' configure.ac

    # Fix seagate kinetic linking
    sed -i 's,libcrypto.a,-lcrypto,g' src/os/Makefile.am
  '' + optionalString (versionAtLeast version "9.0.0") ''
    # Fix gmock
    patchShebangs src/gmock
  '';

  preConfigure = ''
    # Ceph expects the arch command to be usable during configure
    # for detecting the assembly type
    mkdir -p mybin
    echo "#${stdenv.shell} -e" >> mybin/arch
    echo "uname -m" >> mybin/arch
    chmod +x mybin/arch
    PATH="$PATH:$(pwd)/mybin"

    ./autogen.sh

    # Fix the python site-packages install directory
    sed -i "s,\(PYTHON\(\|_EXEC\)_PREFIX=\).*,\1'$lib',g" configure

    # Fix the PYTHONPATH for installing ceph-detect-init to $out
    mkdir -p "$(toPythonPath $out)"
    export PYTHONPATH="$(toPythonPath $out):$PYTHONPATH"
  '';

  configureFlags = [
    (mkOther                               "exec_prefix"         "\${out}")
    (mkOther                               "sysconfdir"          "/etc")
    (mkOther                               "localstatedir"       "/var")
    (mkOther                               "libdir"              "\${lib}/lib")
    (mkOther                               "includedir"          "\${lib}/include")
    (mkWith   true                         "rbd"                  null)
    (mkWith   true                         "cephfs"               null)
    (mkWith   hasRadosgw                   "radosgw"              null)
    (mkWith   true                         "radosstriper"         null)
    (mkWith   hasServer                    "mon"                  null)
    (mkWith   hasServer                    "osd"                  null)
    (mkWith   hasServer                    "mds"                  null)
    (mkEnable true                         "client"               null)
    (mkEnable hasServer                    "server"               null)
    (mkWith   (cryptoStr == "cryptopp")    "cryptopp"             null)
    (mkWith   (cryptoStr == "nss")         "nss"                  null)
    (mkEnable false                        "root-make-check"      null)
    (mkWith   false                        "profiler"             null)
    (mkWith   false                        "debug"                null)
    (mkEnable false                        "coverage"             null)
    (mkWith   (optFuse != null)            "fuse"                 null)
    (mkWith   (malloc == optJemalloc)      "jemalloc"             null)
    (mkWith   (malloc == optGperftools)    "tcmalloc"             null)
    (mkEnable false                        "pgrefdebugging"       null)
    (mkEnable false                        "cephfs-java"          null)
    (mkEnable hasXio                       "xio"                  null)
    (mkWith   (optLibatomic_ops != null)   "libatomic-ops"        null)
    (mkWith   true                         "ocf"                  null)
    (mkWith   hasKinetic                   "kinetic"              null)
    (mkWith   hasRocksdb                   "librocksdb"           null)
    (mkWith   false                        "librocksdb-static"    null)
  ] ++ optional stdenv.isLinux [
    (mkWith   (optLibaio != null)          "libaio"               null)
    (mkWith   (optLibxfs != null)          "libxfs"               null)
    (mkWith   (optZfs != null)             "libzfs"               null)
  ] ++ optional (versionAtLeast version "0.94.3") [
    (mkWith   false                        "tcmalloc-minimal"     null)
  ] ++ optional (versionAtLeast version "9.0.1") [
    (mkWith   false                        "valgrind"             null)
  ] ++ optional (versionAtLeast version "9.0.2") [
    (mkWith   true                         "man-pages"            null)
    (mkWith   true                         "systemd-libexec-dir"  "\${out}/libexec")
  ] ++ optional (versionOlder version "9.1.0") [
    (mkWith   (optLibs3 != null)           "system-libs3"         null)
    (mkWith   true                         "rest-bench"           null)
  ] ++ optional (versionAtLeast version "9.1.0") [
    (mkWith   true                         "rgw-user"             "rgw")
    (mkWith   true                         "rgw-group"            "rgw")
    (mkWith   true                         "systemd-unit-dir"     "\${out}/etc/systemd/system")
    (mkWith   false                        "selinux"              null)  # TODO: Implement
  ];

  preBuild = optionalString (versionAtLeast version "9.0.0") ''
    (cd src/gmock; make -j $NIX_BUILD_CORES)
  '';

  installFlags = [ "sysconfdir=\${out}/etc" ];

  outputs = [ "out" "lib" ];

  postInstall = ''
    # Wrap all of the python scripts
    wrapProgram $out/bin/ceph ${wrapArgs}
    wrapProgram $out/bin/ceph-brag ${wrapArgs}
    wrapProgram $out/bin/ceph-rest-api ${wrapArgs}
    wrapProgram $out/sbin/ceph-create-keys ${wrapArgs}
    wrapProgram $out/sbin/ceph-disk ${wrapArgs}

    # Bring in lib as a native build input
    mkdir -p $out/nix-support
    echo "$lib" > $out/nix-support/propagated-native-build-inputs

    # Fix the python library loading
    find $lib/lib -name \*.pyc -or -name \*.pyd -exec rm {} \;
    for PY in $(find $lib/lib -name \*.py); do
      LIBS="$(sed -n "s/.*find_library('\([^)]*\)').*/\1/p" "$PY")"

      # Delete any calls to find_library
      sed -i '/find_library/d' "$PY"

      # Fix each find_library call
      for LIB in $LIBS; do
        REALLIB="$lib/lib/lib$LIB.so"
        sed -i "s,\(lib$LIB = CDLL(\).*,\1'$REALLIB'),g" "$PY"
      done

      # Reapply compilation optimizations
      NAME=$(basename -s .py "$PY")
      rm -f "$PY"{c,o}
      pushd "$(dirname $PY)"
      python -c "import $NAME"
      python -O -c "import $NAME"
      popd
      test -f "$PY"c
      test -f "$PY"o
    done

    # Fix .la file link dependencies
    find "$lib/lib" -name \*.la | xargs sed -i \
      -e 's,-lboost_[a-z]*,-L${boost.lib}/lib \0,g' \
  '' + optionalString (cryptoStr == "cryptopp") ''
      -e 's,-lcryptopp,-L${optCryptopp}/lib \0,g' \
  '' + optionalString (cryptoStr == "nss") ''
      -e 's,-l\(plds4\|plc4\|nspr4\),-L${optNss}/lib \0,g' \
      -e 's,-l\(ssl3\|smime3\|nss3\|nssutil3\),-L${optNspr}/lib \0,g' \
  '' + ''

  '';

  enableParallelBuilding = true;

  meta = {
    homepage = http://ceph.com/;
    description = "Distributed storage system";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ ak wkennington ];
    platforms = platforms.unix;
  };

  passthru.version = version;
}
