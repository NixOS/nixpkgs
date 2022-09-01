{ lib, stdenv, runCommand, fetchurl
, ensureNewerSourcesHook
, cmake, pkg-config
, which, git
, boost175
, libxml2, zlib, lz4
, openldap, lttng-ust
, babeltrace, gperf
, gtest
, cunit, snappy
, makeWrapper
, leveldb, oath-toolkit
, libnl, libcap_ng
, rdkafka
, nixosTests
, cryptsetup
, sqlite
, lua
, icu
, bzip2
, doxygen
, graphviz
, fmt
, python39

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
, linuxHeaders, util-linux, libuuid, udev, keyutils, rdma-core, rabbitmq-c
, libaio ? null, libxfs ? null, zfs ? null, liburing ? null
, ...
}:

# We must have one crypto library
assert cryptopp != null || (nss != null && nspr != null);

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

  getMeta = description: with lib; {
     homepage = "https://ceph.io/en/";
     inherit description;
     license = with licenses; [ lgpl21 gpl2 bsd3 mit publicDomain ];
     maintainers = with maintainers; [ adev ak johanot krav ];
     platforms = [ "x86_64-linux" "aarch64-linux" ];
   };

  ceph-common = python.pkgs.buildPythonPackage rec{
    pname = "ceph-common";
    inherit src version;

    sourceRoot = "ceph-${version}/src/python-common";

    checkInputs = [ python.pkgs.pytest ];
    propagatedBuildInputs = with python.pkgs; [ pyyaml six ];

    meta = getMeta "Ceph common module for code shared by manager modules";
  };

  # Boost 1.75 is not compatible with Python 3.10
  python = python39;

  boost = boost175.override {
    enablePython = true;
    inherit python;
  };

  ceph-python-env = python.withPackages (ps: [
    ps.sphinx
    ps.flask
    ps.cython
    ps.setuptools
    ps.virtualenv
    # Libraries needed by the python tools
    ps.Mako
    ceph-common
    ps.cherrypy
    ps.cmd2
    ps.colorama
    ps.python-dateutil
    ps.jsonpatch
    ps.pecan
    ps.prettytable
    ps.pyopenssl
    ps.pyjwt
    ps.webob
    ps.bcrypt
    ps.scipy
    ps.six
    ps.pyyaml
  ]);
  sitePackages = ceph-python-env.python.sitePackages;

  version = "16.2.10";
  src = fetchurl {
    url = "http://download.ceph.com/tarballs/ceph-${version}.tar.gz";
    sha256 = "sha256-342+nUV3mCX7QJfZSnKEfnQFCJwJmVQeYnefJwW/AtU=";
  };
in rec {
  ceph = stdenv.mkDerivation {
    pname = "ceph";
    inherit src version;

    patches = [
      ./0000-fix-SPDK-build-env.patch
    ];

    nativeBuildInputs = [
      cmake
      pkg-config which git python.pkgs.wrapPython makeWrapper
      python.pkgs.python # for the toPythonPath function
      (ensureNewerSourcesHook { year = "1980"; })
      python
      fmt
      # for building docs/man-pages presumably
      doxygen
      graphviz
    ];

    buildInputs = cryptoLibsMap.${cryptoStr} ++ [
      boost ceph-python-env libxml2 optYasm optLibatomic_ops optLibs3
      malloc zlib openldap lttng-ust babeltrace gperf gtest cunit
      snappy lz4 oath-toolkit leveldb libnl libcap_ng rdkafka
      cryptsetup sqlite lua icu bzip2
    ] ++ lib.optionals stdenv.isLinux [
      linuxHeaders util-linux libuuid udev keyutils liburing optLibaio optLibxfs optZfs
      # ceph 14
      rdma-core rabbitmq-c
    ] ++ lib.optionals hasRadosgw [
      optFcgi optExpat optCurl optFuse optLibedit
    ];

    pythonPath = [ ceph-python-env "${placeholder "out"}/${ceph-python-env.sitePackages}" ];

    preConfigure =''
      substituteInPlace src/common/module.c --replace "/sbin/modinfo"  "modinfo"
      substituteInPlace src/common/module.c --replace "/sbin/modprobe" "modprobe"
      substituteInPlace src/common/module.c --replace "/bin/grep" "grep"

      # install target needs to be in PYTHONPATH for "*.pth support" check to succeed
      # set PYTHONPATH, so the build system doesn't silently skip installing ceph-volume and others
      export PYTHONPATH=${ceph-python-env}/${sitePackages}:$lib/${sitePackages}:$out/${sitePackages}
      patchShebangs src/script src/spdk src/test src/tools
    '';

    cmakeFlags = [
      "-DWITH_SYSTEM_ROCKSDB=OFF"  # breaks Bluestore
      "-DCMAKE_INSTALL_DATADIR=${placeholder "lib"}/lib"

      "-DWITH_SYSTEM_BOOST=ON"
      "-DWITH_SYSTEM_GTEST=ON"
      "-DMGR_PYTHON_VERSION=${ceph-python-env.python.pythonVersion}"
      "-DWITH_SYSTEMD=OFF"
      "-DWITH_TESTS=OFF"
      "-DWITH_CEPHFS_SHELL=ON"
      # TODO breaks with sandbox, tries to download stuff with npm
      "-DWITH_MGR_DASHBOARD_FRONTEND=OFF"
      # WITH_XFS has been set default ON from Ceph 16, keeping it optional in nixpkgs for now
      ''-DWITH_XFS=${lib.boolToCMakeString (optLibxfs != null)}''
    ] ++ lib.optional stdenv.isLinux "-DWITH_SYSTEM_LIBURING=ON";

    postFixup = ''
      wrapPythonPrograms
      wrapProgram $out/bin/ceph-mgr --prefix PYTHONPATH ":" "$(toPythonPath ${placeholder "out"}):$(toPythonPath ${ceph-python-env})"

      # Test that ceph-volume exists since the build system has a tendency to
      # silently drop it with misconfigurations.
      test -f $out/bin/ceph-volume
    '';

    outputs = [ "out" "lib" "dev" "doc" "man" ];

    doCheck = false; # uses pip to install things from the internet

    # Takes 7+h to build with 2 cores.
    requiredSystemFeatures = [ "big-parallel" ];

    meta = getMeta "Distributed storage system";

    passthru.version = version;
    passthru.tests = { inherit (nixosTests) ceph-single-node ceph-multi-node ceph-single-node-bluestore; };
  };

  ceph-client = runCommand "ceph-client-${version}" {
      meta = getMeta "Tools needed to mount Ceph's RADOS Block Devices/Cephfs";
    } ''
      mkdir -p $out/{bin,etc,${sitePackages},share/bash-completion/completions}
      cp -r ${ceph}/bin/{ceph,.ceph-wrapped,rados,rbd,rbdmap} $out/bin
      cp -r ${ceph}/bin/ceph-{authtool,conf,dencoder,rbdnamer,syn} $out/bin
      cp -r ${ceph}/bin/rbd-replay* $out/bin
      cp -r ${ceph}/sbin/mount.ceph $out/bin
      cp -r ${ceph}/sbin/mount.fuse.ceph $out/bin
      ln -s bin $out/sbin
      cp -r ${ceph}/${sitePackages}/* $out/${sitePackages}
      cp -r ${ceph}/etc/bash_completion.d $out/share/bash-completion/completions
      # wrapPythonPrograms modifies .ceph-wrapped, so lets just update its paths
      substituteInPlace $out/bin/ceph          --replace ${ceph} $out
      substituteInPlace $out/bin/.ceph-wrapped --replace ${ceph} $out
   '';
}
