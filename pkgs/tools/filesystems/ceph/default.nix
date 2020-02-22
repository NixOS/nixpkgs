{ stdenv, runCommand, fetchurl
, ensureNewerSourcesHook
, cmake, pkgconfig
, which, git
, boost, python3Packages
, libxml2, zlib, lz4
, openldap, lttng-ust
, babeltrace, gperf
, gtest
, cunit, snappy
, rocksdb, makeWrapper
, leveldb, oathToolkit
, libnl, libcap_ng

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
    ps.pyyaml
  ]);
  sitePackages = ceph-python-env.python.sitePackages;

  version = "14.2.6";
in rec {
  ceph = stdenv.mkDerivation {
    pname = "ceph";
    inherit version;

    src = fetchurl {
      url = "http://download.ceph.com/tarballs/ceph-${version}.tar.gz";
      sha256 = "0qkyrb25r2a57n6k8ncb43x7hvhkmpi7abhfyi98mlz2lhmhzlm1";
    };

    patches = [
      ./0000-fix-SPDK-build-env.patch
      ./0000-dont-check-cherrypy-version.patch
    ];

    nativeBuildInputs = [
      cmake
      pkgconfig which git python3Packages.wrapPython makeWrapper
      python3Packages.python # for the toPythonPath function
      (ensureNewerSourcesHook { year = "1980"; })
    ];

    buildInputs = cryptoLibsMap.${cryptoStr} ++ [
      boost ceph-python-env libxml2 optYasm optLibatomic_ops optLibs3
      malloc zlib openldap lttng-ust babeltrace gperf gtest cunit
      snappy rocksdb lz4 oathToolkit leveldb libnl libcap_ng
    ] ++ optionals stdenv.isLinux [
      linuxHeaders utillinux libuuid udev keyutils optLibaio optLibxfs optZfs
      # ceph 14
      rdma-core rabbitmq-c
    ] ++ optionals hasRadosgw [
      optFcgi optExpat optCurl optFuse optLibedit
    ];

    pythonPath = [ ceph-python-env "${placeholder "out"}/${ceph-python-env.sitePackages}" ];

    preConfigure =''
      substituteInPlace src/common/module.c --replace "/sbin/modinfo"  "modinfo"
      substituteInPlace src/common/module.c --replace "/sbin/modprobe" "modprobe"

      # for pybind/rgw to find internal dep
      export LD_LIBRARY_PATH="$PWD/build/lib''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH"
      # install target needs to be in PYTHONPATH for "*.pth support" check to succeed
      # set PYTHONPATH, so the build system doesn't silently skip installing ceph-volume and others
      export PYTHONPATH=${ceph-python-env}/${sitePackages}:$lib/${sitePackages}:$out/${sitePackages}
      patchShebangs src/script src/spdk src/test src/tools
    '';

    cmakeFlags = [
      "-DWITH_PYTHON3=ON"
      "-DWITH_SYSTEM_ROCKSDB=OFF"
      "-DCMAKE_INSTALL_DATADIR=${placeholder "lib"}/lib"


      "-DWITH_SYSTEM_BOOST=ON"
      "-DWITH_SYSTEM_ROCKSDB=ON"
      "-DWITH_SYSTEM_GTEST=ON"
      "-DMGR_PYTHON_VERSION=${ceph-python-env.python.pythonVersion}"
      "-DWITH_SYSTEMD=OFF"
      "-DWITH_TESTS=OFF"
      # TODO breaks with sandbox, tries to download stuff with npm
      "-DWITH_MGR_DASHBOARD_FRONTEND=OFF"
    ];

    postFixup = ''
      wrapPythonPrograms
      wrapProgram $out/bin/ceph-mgr --prefix PYTHONPATH ":" "$(toPythonPath ${placeholder "out"}):$(toPythonPath ${ceph-python-env})"

      # Test that ceph-volume exists since the build system has a tendency to
      # silently drop it with misconfigurations.
      test -f $out/bin/ceph-volume
    '';

    enableParallelBuilding = true;

    outputs = [ "out" "lib" "dev" "doc" "man" ];

    doCheck = false; # uses pip to install things from the internet

    meta = {
      homepage = https://ceph.com/;
      description = "Distributed storage system";
      license = with licenses; [ lgpl21 gpl2 bsd3 mit publicDomain ];
      maintainers = with maintainers; [ adev ak krav johanot ];
      platforms = [ "x86_64-linux" ];
    };

    passthru.version = version;
  };

  ceph-client = runCommand "ceph-client-${version}" {
     meta = {
        homepage = https://ceph.com/;
        description = "Tools needed to mount Ceph's RADOS Block Devices";
        license = with licenses; [ lgpl21 gpl2 bsd3 mit publicDomain ];
        maintainers = with maintainers; [ adev ak johanot krav ];
        platforms = [ "x86_64-linux" ];
      };
    } ''
      mkdir -p $out/{bin,etc,${sitePackages}}
      cp -r ${ceph}/bin/{ceph,.ceph-wrapped,rados,rbd,rbdmap} $out/bin
      cp -r ${ceph}/bin/ceph-{authtool,conf,dencoder,rbdnamer,syn} $out/bin
      cp -r ${ceph}/bin/rbd-replay* $out/bin
      cp -r ${ceph}/${sitePackages} $out/${sitePackages}
      cp -r ${ceph}/etc/bash_completion.d $out/etc
      # wrapPythonPrograms modifies .ceph-wrapped, so lets just update its paths
      substituteInPlace $out/bin/ceph          --replace ${ceph} $out
      substituteInPlace $out/bin/.ceph-wrapped --replace ${ceph} $out
   '';
}
