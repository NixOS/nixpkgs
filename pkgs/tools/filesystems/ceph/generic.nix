{ stdenv, ensureNewerSourcesHook, cmake, pkgconfig
, which, git
, boost, python2Packages
, libxml2, zlib
, openldap, lttng-ust
, babeltrace, gperf
, cunit, snappy
, rocksdb, makeWrapper

# Optional Dependencies
, yasm ? null, fcgi ? null, expat ? null
, curl ? null, fuse ? null
, libedit ? null, libatomic_ops ? null, kinetic-cpp-client ? null
, libs3 ? null

# Mallocs
, jemalloc ? null, gperftools ? null

# Crypto Dependencies
, cryptopp ? null
, nss ? null, nspr ? null

# Linux Only Dependencies
, linuxHeaders, libuuid, udev, keyutils, libaio ? null, libxfs ? null
, zfs ? null

# Version specific arguments
, version, src ? [], buildInputs ? []
, ...
}:

# We must have one crypto library
assert cryptopp != null || (nss != null && nspr != null);

with stdenv;
with stdenv.lib;
let

  shouldUsePkg = pkg_: let pkg = (builtins.tryEval pkg_).value;
    in if pkg.meta.available or false then pkg else null;

  optYasm = shouldUsePkg yasm;
  optFcgi = shouldUsePkg fcgi;
  optExpat = shouldUsePkg expat;
  optCurl = shouldUsePkg curl;
  optFuse = shouldUsePkg fuse;
  optLibedit = shouldUsePkg libedit;
  optLibatomic_ops = shouldUsePkg libatomic_ops;
  optKinetic-cpp-client = shouldUsePkg kinetic-cpp-client;
  optLibs3 = if versionAtLeast version "10.0.0" then null else shouldUsePkg libs3;

  optJemalloc = shouldUsePkg jemalloc;
  optGperftools = shouldUsePkg gperftools;

  optCryptopp = shouldUsePkg cryptopp;
  optNss = shouldUsePkg nss;
  optNspr = shouldUsePkg nspr;

  optLibaio = shouldUsePkg libaio;
  optLibxfs = shouldUsePkg libxfs;
  optZfs = shouldUsePkg zfs;

  hasRadosgw = optFcgi != null && optExpat != null && optCurl != null && optLibedit != null;


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

  ceph-python-env = python2Packages.python.withPackages (ps: [
    ps.sphinx
    ps.flask
    ps.argparse
    ps.cython
    ps.setuptools
    ps.pip
    # Libraries needed by the python tools
    ps.Mako
    ps.pecan
    ps.prettytable
    ps.webob
    ps.cherrypy
  ]);

in
stdenv.mkDerivation {
  name="ceph-${version}";

  inherit src;

  patches = [
 #   ./ceph-patch-cmake-path.patch
    ./0001-kv-RocksDBStore-API-break-additional.patch
  ] ++ optionals stdenv.isLinux [
    ./0002-fix-absolute-include-path.patch
  ];

  nativeBuildInputs = [
    cmake
    pkgconfig which git python2Packages.wrapPython makeWrapper
    (ensureNewerSourcesHook { year = "1980"; })
  ];

  buildInputs = buildInputs ++ cryptoLibsMap.${cryptoStr} ++ [
    boost ceph-python-env libxml2 optYasm optLibatomic_ops optLibs3
    malloc zlib openldap lttng-ust babeltrace gperf cunit
    snappy rocksdb
  ] ++ optionals stdenv.isLinux [
    linuxHeaders libuuid udev keyutils optLibaio optLibxfs optZfs
  ] ++ optionals hasRadosgw [
    optFcgi optExpat optCurl optFuse optLibedit
  ] ++ optionals hasKinetic [
    optKinetic-cpp-client
  ];


  preConfigure =''
    # rip off submodule that interfer with system libs
	rm -rf src/boost
	rm -rf src/rocksdb

	# require LD_LIBRARY_PATH for cython to find internal dep
	export LD_LIBRARY_PATH="$PWD/build/lib:$LD_LIBRARY_PATH"

	# requires setuptools due to embedded in-cmake setup.py usage
	export PYTHONPATH="${python2Packages.setuptools}/lib/python2.7/site-packages/:$PYTHONPATH"
  '';

  cmakeFlags = [
    "-DENABLE_GIT_VERSION=OFF"
    "-DWITH_SYSTEM_BOOST=ON"
    "-DWITH_SYSTEM_ROCKSDB=ON"
    "-DWITH_LEVELDB=OFF"

    # enforce shared lib
    "-DBUILD_SHARED_LIBS=ON"

    # disable cephfs, cmake build broken for now
    "-DWITH_CEPHFS=OFF"
    "-DWITH_LIBCEPHFS=OFF"
  ];

  postFixup = ''
    wrapPythonPrograms
    wrapProgram $out/bin/ceph-mgr --set PYTHONPATH $out/${python2Packages.python.sitePackages}
  '';

  enableParallelBuilding = true;

  outputs = [ "dev" "lib" "out" "doc" ];

  meta = {
    homepage = https://ceph.com/;
    description = "Distributed storage system";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ adev ak wkennington ];
    platforms = platforms.unix;
  };

  passthru.version = version;
}
