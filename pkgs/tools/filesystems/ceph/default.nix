{ lib
, stdenv
, runCommand
, fetchurl
, fetchFromGitHub

# Build time
, cmake
, ensureNewerSourcesHook
, fmt
, git
, makeWrapper
, pkg-config
, which

# Tests
, nixosTests

# Runtime dependencies
, arrow-cpp
, babeltrace
, boost179
, bzip2
, cryptsetup
, cimg
, cunit
, doxygen
, gperf
, graphviz
, gtest
, icu
, jsoncpp
, libcap_ng
, libnl
, libxml2
, lttng-ust
, lua
, lz4
, oath-toolkit
, openldap
, python310
, rdkafka
, rocksdb
, snappy
, sqlite
, utf8proc
, zlib
, zstd

# Optional Dependencies
, curl ? null
, expat ? null
, fuse ? null
, libatomic_ops ? null
, libedit ? null
, libs3 ? null
, yasm ? null

# Mallocs
, gperftools ? null
, jemalloc ? null

# Crypto Dependencies
, cryptopp ? null
, nspr ? null
, nss ? null

# Linux Only Dependencies
, linuxHeaders
, util-linux
, libuuid
, udev
, keyutils
, rdma-core
, rabbitmq-c
, libaio ? null
, libxfs ? null
, liburing ? null
, zfs ? null
, ...
}:

# We must have one crypto library
assert cryptopp != null || (nss != null && nspr != null);

let
  shouldUsePkg = pkg: if pkg != null && pkg.meta.available then pkg else null;

  optYasm = shouldUsePkg yasm;
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

  # Downgrade rocksdb, 7.10 breaks ceph
  rocksdb' = rocksdb.overrideAttrs (oldAttrs: {
    version = "7.9.2";
    src = fetchFromGitHub {
      owner = "facebook";
      repo = "rocksdb";
      rev = "refs/tags/v7.9.2";
      hash = "sha256-5P7IqJ14EZzDkbjaBvbix04ceGGdlWBuVFH/5dpD5VM=";
    };
  });

  hasRadosgw = optExpat != null && optCurl != null && optLibedit != null;

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

  ceph-common = with python.pkgs; buildPythonPackage {
    pname = "ceph-common";
    inherit src version;

    sourceRoot = "ceph-${version}/src/python-common";

    propagatedBuildInputs = [
      pyyaml
    ];

    nativeCheckInputs = [
      pytestCheckHook
    ];

    disabledTests = [
      # requires network access
      "test_valid_addr"
    ];

    meta = getMeta "Ceph common module for code shared by manager modules";
  };

  # Watch out for python <> boost compatibility
  python = python310.override {
    packageOverrides = self: super: {
      sqlalchemy = super.sqlalchemy.overridePythonAttrs (oldAttrs: rec {
        version = "1.4.46";
        src = super.fetchPypi {
          pname = "SQLAlchemy";
          inherit version;
          hash = "sha256-aRO4JH2KKS74MVFipRkx4rQM6RaB8bbxj2lwRSAMSjA=";
        };
        nativeCheckInputs = oldAttrs.nativeCheckInputs ++ (with super; [
          pytest-xdist
        ]);
        disabledTestPaths = (oldAttrs.disabledTestPaths or []) ++ [
          "test/aaa_profiling"
          "test/ext/mypy"
        ];
      });
    };
  };

  boost = boost179.override {
    enablePython = true;
    inherit python;
  };

  # TODO: split this off in build and runtime environment
  ceph-python-env = python.withPackages (ps: with ps; [
    ceph-common

    # build time
    cython

    # debian/control
    bcrypt
    cherrypy
    influxdb
    jinja2
    kubernetes
    natsort
    numpy
    pecan
    prettytable
    pyjwt
    pyopenssl
    python-dateutil
    pyyaml
    requests
    routes
    scikit-learn
    scipy
    setuptools
    sphinx
    virtualenv
    werkzeug

    # src/pybind/mgr/requirements-required.txt
    cryptography
    jsonpatch

    # src/tools/cephfs/shell/setup.py
    cmd2
    colorama
  ]);
  sitePackages = ceph-python-env.python.sitePackages;

  version = "17.2.5";
  src = fetchurl {
    url = "http://download.ceph.com/tarballs/ceph-${version}.tar.gz";
    hash = "sha256-NiJpwUeROvh0siSaRoRrDm+C0s61CvRiIrbd7JmRspo=";
  };
in rec {
  ceph = stdenv.mkDerivation {
    pname = "ceph";
    inherit src version;

    nativeBuildInputs = [
      cmake
      fmt
      git
      makeWrapper
      pkg-config
      python
      python.pkgs.python # for the toPythonPath function
      python.pkgs.wrapPython
      which
      (ensureNewerSourcesHook { year = "1980"; })
      # for building docs/man-pages presumably
      doxygen
      graphviz
    ];

    enableParallelBuilding = true;

    buildInputs = cryptoLibsMap.${cryptoStr} ++ [
      arrow-cpp
      babeltrace
      boost
      bzip2
      ceph-python-env
      cimg
      cryptsetup
      cunit
      gperf
      gtest
      jsoncpp
      icu
      libcap_ng
      libnl
      libxml2
      lttng-ust
      lua
      lz4
      malloc
      oath-toolkit
      openldap
      optLibatomic_ops
      optLibs3
      optYasm
      rdkafka
      rocksdb'
      snappy
      sqlite
      utf8proc
      zlib
      zstd
    ] ++ lib.optionals stdenv.isLinux [
      keyutils
      liburing
      libuuid
      linuxHeaders
      optLibaio
      optLibxfs
      optZfs
      rabbitmq-c
      rdma-core
      udev
      util-linux
    ] ++ lib.optionals hasRadosgw [
      optCurl
      optExpat
      optFuse
      optLibedit
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
      "-DCMAKE_INSTALL_DATADIR=${placeholder "lib"}/lib"

      "-DMGR_PYTHON_VERSION=${ceph-python-env.python.pythonVersion}"
      "-DWITH_CEPHFS_SHELL:BOOL=ON"
      "-DWITH_SYSTEMD:BOOL=OFF"
      "-DWITH_TESTS:BOOL=OFF"

      # Use our own libraries, where possible
      "-DWITH_SYSTEM_ARROW:BOOL=ON"
      "-DWITH_SYSTEM_BOOST:BOOL=ON"
      "-DWITH_SYSTEM_CIMG:BOOL=ON"
      "-DWITH_SYSTEM_JSONCPP:BOOL=ON"
      "-DWITH_SYSTEM_GTEST:BOOL=ON"
      "-DWITH_SYSTEM_ROCKSDB:BOOL=ON"
      "-DWITH_SYSTEM_UTF8PROC:BOOL=ON"
      "-DWITH_SYSTEM_ZSTD:BOOL=ON"

      # TODO breaks with sandbox, tries to download stuff with npm
      "-DWITH_MGR_DASHBOARD_FRONTEND:BOOL=OFF"
      # no matching function for call to 'parquet::PageReader::Open(std::shared_ptr<arrow::io::InputStream>&, int64_t, arrow::Compression::type, parquet::MemoryPool*, parquet::CryptoContext*)'
      "-DWITH_RADOSGW_SELECT_PARQUET:BOOL=OFF"
      # WITH_XFS has been set default ON from Ceph 16, keeping it optional in nixpkgs for now
      ''-DWITH_XFS=${if optLibxfs != null then "ON" else "OFF"}''
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

    passthru = {
      inherit version;
      tests = {
        inherit (nixosTests)
          ceph-multi-node
          ceph-single-node
          ceph-single-node-bluestore;
      };
    };
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
