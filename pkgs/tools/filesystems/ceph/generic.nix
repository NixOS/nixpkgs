{ stdenv, fetchurl, ensureNewerSourcesHook, cmake, pkgconfig
, which, git
, boost, python2Packages
, libxml2, zlib, lz4
, openldap, lttngUst
, babeltrace, gperf
, cunit, snappy
, rocksdb, makeWrapper
, leveldb, oathToolkit

# Optional Dependencies
, yasm ? null, fcgi ? null, expat ? null
, curl ? null, fuse ? null,
, libedit ? null, libatomic_ops ? null, kinetic-cpp-client ? null
, libs3 ? null

# Mallocs
, jemalloc ? null, gperftools ? null

# Crypto Dependencies
, cryptopp ? null
, nss ? null, nspr ? null

# Linux Only Dependencies
, linuxHeaders, utillinux, libuuid, udev, keyutils
, libaio ? null, libxfs ? null, zfs ? null
, ...
}:

# We must have one crypto library
assert cryptopp != null || (nss != null && nspr != null);

with stdenv; with stdenv.lib;
let
  shouldUsePkg = pkg: if pkg != null && pkg.meta.available then pkg else null;

  optYasm = shouldUsePkg yasm;
  optFcgi = shouldUsePkg fcgi;
  optExpat = shouldUsePkg expat;
  optCurl = shouldUsePkg curl;
  optFuse = shouldUsePkg fuse;
  optLibedit = shouldUsePkg libedit;
  optLibatomic_ops = shouldUsePkg libatomic_ops;
  optKinetic-cpp-client = shouldUsePkg kinetic-cpp-client;
  optLibs3 = shouldUsePkg libs3;

  optJemalloc = shouldUsePkg jemalloc;
  optGperftools = shouldUsePkg gperftools;

  optCryptopp = shouldUsePkg cryptopp;
  optNss = shouldUsePkg nss;
  optNspr = shouldUsePkg nspr;

  optLibaio = shouldUsePkg libaio;
  optLibxfs = shouldUsePkg libxfs;
  optZfs = shouldUsePkg zfs;

  hasRadosgw = optFcgi != null && optExpat != null && optCurl != null && optLibedit != null;


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
    ps.cython
    ps.setuptools
    ps.virtualenv
    # Libraries needed by the python tools
    ps.Mako
    ps.cherrypy
    ps.pecan
    ps.prettytable
    ps.webob
    ps.bcrypt
  ]);

in
stdenv.mkDerivation {
  name="ceph-${version}";

  inherit src;

  patches = [
    ./0000-fix-SPDK-build-env.patch

    # TODO: remove when https://github.com/ceph/ceph/pull/21289 is merged
    ./0000-ceph-volume-allow-loop.patch
    # TODO: remove when https://github.com/ceph/ceph/pull/20938 is merged
    ./0000-dont-hardcode-bin-paths.patch
  ];

  nativeBuildInputs = [
    cmake
    pkgconfig which git python2Packages.wrapPython makeWrapper
    (ensureNewerSourcesHook { year = "1980"; })
  ];

  buildInputs = cryptoLibsMap.${cryptoStr} ++ [
    boost ceph-python-env libxml2 optYasm optLibatomic_ops optLibs3
    malloc zlib openldap lttngUst babeltrace gperf cunit
    snappy rocksdb lz4 oathToolkit leveldb
    optKinetic-cpp-client
  ] ++ optionals stdenv.isLinux [
    linuxHeaders utillinux libuuid udev keyutils optLibaio optLibxfs optZfs
  ] ++ optionals hasRadosgw [
    optFcgi optExpat optCurl optFuse optLibedit
  ];

  preConfigure =''
    # require LD_LIBRARY_PATH for pybind/rgw to find internal dep
    export LD_LIBRARY_PATH="$PWD/build/lib:$LD_LIBRARY_PATH"
    patchShebangs src/spdk
  '';

  cmakeFlags = [
    "-DWITH_SYSTEM_ROCKSDB=ON"
    "-DROCKSDB_INCLUDE_DIR=${rocksdb}/include/rocksdb"
    "-DWITH_SYSTEM_BOOST=OFF"
    "-DWITH_SYSTEMD=OFF"
    "-DWITH_TESTS=OFF"
    # TODO breaks with sandbox, tries to download stuff with npm
    "-DWITH_MGR_DASHBOARD_FRONTEND=OFF"
  ];

  postInstall = ''
    mkdir -p $client/{bin,etc,lib/python2.7/site-packages}
    mv $out/bin/{ceph,rados,rbd,rbdmap} $client/bin
    mv $out/bin/ceph-{authtool,conf,dencoder,post-file,rbdnamer,syn} $client/bin
    mv $out/bin/rbd-replay* $client/bin
    mv $out/lib/python2.7/site-packages/ceph_{argparse,daemon}.py $client/lib/python2.7/site-packages
    mv $out/etc/bash_completion.d $client/etc
    mkdir -p $man/share
    mv $out/share/man $man/share
  '';

  postFixup = ''
    wrapPythonProgramsIn "$out/bin" "$out $pythonPath"
    wrapPythonProgramsIn "$client/bin" "$client $out $pythonPath"
    wrapProgram $out/bin/ceph-mgr --prefix PYTHONPATH ":" "$out/lib/ceph/mgr:$out/lib/python2.7/site-packages/"
  '';

  enableParallelBuilding = true;

  outputs = [ "out" "lib" "dev" "doc" "client" "man" ];

  meta = {
    homepage = https://ceph.com/;
    description = "Distributed storage system";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ adev ak ];
    platforms = platforms.unix;
    outputsToInstall = [ "out" "client" ];
  };

  passthru.version = version;
}
