{ stdenv, runCommand, fetchurl
, ensureNewerSourcesHook
, cmake, pkgconfig
, which, git
, boost, python2Packages
, libxml2, zlib, lz4
, openldap, lttng-ust
, babeltrace, gperf
, cunit, snappy
, rocksdb, makeWrapper
, leveldb, oathToolkit

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

  version = "13.2.4";
in rec {
  ceph = stdenv.mkDerivation {
    name="ceph-${version}";

    src = fetchurl {
      url = "http://download.ceph.com/tarballs/ceph-${version}.tar.gz";
      sha256 = "0g2mc6rp84ia44vz8kl449820m9hmfavzfmwn8fy6li14xr8a00w";
    };

    patches = [
      ./0000-fix-SPDK-build-env.patch
      # TODO: remove when https://github.com/ceph/ceph/pull/21289 is merged
      ./0000-ceph-volume-allow-loop.patch
    ];

    nativeBuildInputs = [
      cmake
      pkgconfig which git python2Packages.wrapPython makeWrapper
      (ensureNewerSourcesHook { year = "1980"; })
    ];

    buildInputs = cryptoLibsMap.${cryptoStr} ++ [
      boost ceph-python-env libxml2 optYasm optLibatomic_ops optLibs3
      malloc zlib openldap lttng-ust babeltrace gperf cunit
      snappy rocksdb lz4 oathToolkit leveldb
      optKinetic-cpp-client
    ] ++ optionals stdenv.isLinux [
      linuxHeaders utillinux libuuid udev keyutils optLibaio optLibxfs optZfs
    ] ++ optionals hasRadosgw [
      optFcgi optExpat optCurl optFuse optLibedit
    ];

    preConfigure =''
      substituteInPlace src/common/module.c --replace "/sbin/modinfo"  "modinfo"
      substituteInPlace src/common/module.c --replace "/sbin/modprobe" "modprobe"
      # Since Boost 1.67 this seems to have changed
      substituteInPlace CMakeLists.txt --replace "list(APPEND BOOST_COMPONENTS python)" "list(APPEND BOOST_COMPONENTS python27)"
      substituteInPlace src/CMakeLists.txt --replace "Boost::python " "Boost::python27 "

      # for pybind/rgw to find internal dep
      export LD_LIBRARY_PATH="$PWD/build/lib:$LD_LIBRARY_PATH"
      # install target needs to be in PYTHONPATH for "*.pth support" check to succeed
      export PYTHONPATH=$lib/lib/python2.7/site-packages/:$out/lib/python2.7/site-packages/

      patchShebangs src/spdk
    '';

    cmakeFlags = [
      "-DWITH_SYSTEM_ROCKSDB=ON"
      "-DROCKSDB_INCLUDE_DIR=${rocksdb}/include/rocksdb"
      "-DWITH_SYSTEM_BOOST=ON"
      "-DWITH_SYSTEMD=OFF"
      "-DWITH_TESTS=OFF"
      # TODO breaks with sandbox, tries to download stuff with npm
      "-DWITH_MGR_DASHBOARD_FRONTEND=OFF"
    ];

    postFixup = ''
      wrapPythonPrograms
      wrapProgram $out/bin/ceph-mgr --prefix PYTHONPATH ":" "$lib/lib/ceph/mgr:$out/lib/python2.7/site-packages/"
    '';

    enableParallelBuilding = true;

    outputs = [ "out" "lib" "dev" "doc" "man" ];

    meta = {
      homepage = https://ceph.com/;
      description = "Distributed storage system";
      license = with licenses; [ lgpl21 gpl2 bsd3 mit publicDomain ];
      maintainers = with maintainers; [ adev ak krav ];
      platforms = platforms.unix;
    };

    passthru.version = version;
  };

  ceph-client = runCommand "ceph-client-${version}" {
     meta = {
        homepage = https://ceph.com/;
        description = "Tools needed to mount Ceph's RADOS Block Devices";
        license = with licenses; [ lgpl21 gpl2 bsd3 mit publicDomain ];
        maintainers = with maintainers; [ adev ak krav ];
        platforms = platforms.unix;
      };
    } ''
      mkdir -p $out/{bin,etc,lib/python2.7/site-packages}
      cp -r ${ceph}/bin/{ceph,.ceph-wrapped,rados,rbd,rbdmap} $out/bin
      cp -r ${ceph}/bin/ceph-{authtool,conf,dencoder,rbdnamer,syn} $out/bin
      cp -r ${ceph}/bin/rbd-replay* $out/bin
      cp -r ${ceph}/lib/python2.7/site-packages $out/lib/python2.7/
      cp -r ${ceph}/etc/bash_completion.d $out/etc
      # wrapPythonPrograms modifies .ceph-wrapped, so lets just update its paths
      substituteInPlace $out/bin/ceph          --replace ${ceph} $out
      substituteInPlace $out/bin/.ceph-wrapped --replace ${ceph} $out
   '';
}
