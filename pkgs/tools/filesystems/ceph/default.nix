{ stdenv, runCommand, fetchurl
, ensureNewerSourcesHook
, cmake, pkgconfig
, which, git
, boost, python3Packages
, libxml2, zlib, lz4
, openldap, lttng-ust
, babeltrace, gperf
, cunit, snappy
, rocksdb, makeWrapper
, leveldb, oathToolkit, removeReferencesTo

# Optional Dependencies
, yasm ? null, fcgi ? null, expat ? null
, curl ? null, fuse ? null
, libedit ? null, libatomic_ops ? null
, libs3 ? null

# Mallocs
, jemalloc ? null, gperftools ? null

# Crypto Dependencies
, cryptopp ? null
, nss ? null, nspr ? null

# Linux Only Dependencies
, linuxHeaders, utillinux, libuuid, udev, keyutils, rdma-core, rabbitmq-c
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

  ceph-python-env = python3Packages.python.withPackages (ps: [
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
    ps.pyjwt
    ps.webob
    ps.bcrypt
    ps.six
  ]);

  version = "14.2.3";
in rec {
  ceph = stdenv.mkDerivation {
    pname = "ceph";
    inherit version;

    src = fetchurl {
      url = "http://download.ceph.com/tarballs/ceph-${version}.tar.gz";
      sha256 = "1pa8czb205pz4vjfh82gsgickj3cdjrx51mcx7acsyqgp3dfvl33";
    };

    patches = [
      ./0000-fix-SPDK-build-env.patch
      ./0000-dont-check-cherrypy-version.patch
    ];

    nativeBuildInputs = [
      cmake
      pkgconfig which git python3Packages.wrapPython makeWrapper
      (ensureNewerSourcesHook { year = "1980"; })
    ];

    buildInputs = cryptoLibsMap.${cryptoStr} ++ [
      boost ceph-python-env libxml2 optYasm optLibatomic_ops optLibs3
      malloc zlib openldap lttng-ust babeltrace gperf cunit
      snappy rocksdb lz4 oathToolkit leveldb
      removeReferencesTo
    ] ++ optionals stdenv.isLinux [
      linuxHeaders utillinux libuuid udev keyutils optLibaio optLibxfs optZfs
      # ceph 14
      rdma-core rabbitmq-c
    ] ++ optionals hasRadosgw [
      optFcgi optExpat optCurl optFuse optLibedit
    ];

    preConfigure =''
      substituteInPlace src/common/module.c --replace "/sbin/modinfo"  "modinfo"
      substituteInPlace src/common/module.c --replace "/sbin/modprobe" "modprobe"
      # Since Boost 1.67 this seems to have changed
      substituteInPlace CMakeLists.txt --replace "list(APPEND BOOST_COMPONENTS python)" "list(APPEND BOOST_COMPONENTS python37)"
      substituteInPlace src/CMakeLists.txt --replace "Boost::python " "Boost::python37 "

      # for pybind/rgw to find internal dep
      export LD_LIBRARY_PATH="$PWD/build/lib:$LD_LIBRARY_PATH"
      # install target needs to be in PYTHONPATH for "*.pth support" check to succeed
      export PYTHONPATH=${ceph-python-env}/lib/python3.7/site-packages:$lib/lib/python3.7/site-packages/:$out/lib/python3.7/site-packages/

      patchShebangs src/spdk
    '';

    cmakeFlags = [
      "-DWITH_PYTHON3=ON"
      "-DWITH_SYSTEM_ROCKSDB=OFF"

      "-DWITH_SYSTEM_BOOST=ON"
      "-DWITH_SYSTEMD=OFF"
      "-DWITH_TESTS=OFF"
      # TODO breaks with sandbox, tries to download stuff with npm
      "-DWITH_MGR_DASHBOARD_FRONTEND=OFF"
    ];

    preFixup = ''
      find $lib -type f -exec remove-references-to -t $out '{}' +
      mv $out/share/ceph/mgr $lib/lib/ceph/
    '';

    postFixup = ''
      export PYTHONPATH="${ceph-python-env}/lib/python3.7/site-packages:$lib/lib/ceph/mgr:$out/lib/python3.7/site-packages/"
      wrapPythonPrograms
      wrapProgram $out/bin/ceph-mgr --prefix PYTHONPATH ":" "${ceph-python-env}/lib/python3.7/site-packages:$lib/lib/ceph/mgr:$out/lib/python3.7/site-packages/"
      wrapProgram $out/bin/ceph-volume --prefix PYTHONPATH ":" "${ceph-python-env}/lib/python3.7/site-packages:$lib/lib/ceph/mgr:$out/lib/python3.7/site-packages/"
    '';

    enableParallelBuilding = true;

    outputs = [ "out" "lib" "dev" "doc" "man" ];

    meta = {
      homepage = https://ceph.com/;
      description = "Distributed storage system";
      license = with licenses; [ lgpl21 gpl2 bsd3 mit publicDomain ];
      maintainers = with maintainers; [ adev ak krav johanot ];
      platforms = platforms.unix;
    };

    passthru.version = version;
  };

  ceph-client = runCommand "ceph-client-${version}" {
     meta = {
        homepage = https://ceph.com/;
        description = "Tools needed to mount Ceph's RADOS Block Devices";
        license = with licenses; [ lgpl21 gpl2 bsd3 mit publicDomain ];
        maintainers = with maintainers; [ adev ak johanot krav ];
        platforms = platforms.unix;
      };
    } ''
      mkdir -p $out/{bin,etc,lib/python3.7/site-packages}
      cp -r ${ceph}/bin/{ceph,.ceph-wrapped,rados,rbd,rbdmap} $out/bin
      cp -r ${ceph}/bin/ceph-{authtool,conf,dencoder,rbdnamer,syn} $out/bin
      cp -r ${ceph}/bin/rbd-replay* $out/bin
      cp -r ${ceph}/lib/python3.7/site-packages $out/lib/python3.7/
      cp -r ${ceph}/etc/bash_completion.d $out/etc
      # wrapPythonPrograms modifies .ceph-wrapped, so lets just update its paths
      substituteInPlace $out/bin/ceph          --replace ${ceph} $out
      substituteInPlace $out/bin/.ceph-wrapped --replace ${ceph} $out
   '';
}
