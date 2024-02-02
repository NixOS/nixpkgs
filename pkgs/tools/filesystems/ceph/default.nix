{ lib
, stdenv
, runCommand
, fetchurl
, fetchFromGitHub
, fetchPypi

# Build time
, cmake
, ensureNewerSourcesHook
, fmt
, git
, makeWrapper
, nasm
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
, cunit
, doxygen
, gperf
, graphviz
, gnugrep
, gtest
, icu
, kmod
, libcap
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

# Dependencies of overridden Python dependencies, hopefully we can remove these soon.
, rustPlatform

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
  shouldUsePkg = pkg: if pkg != null && lib.meta.availableOn stdenv.hostPlatform pkg then pkg else null;

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
  rocksdb' = rocksdb.overrideAttrs {
    version = "7.9.2";
    src = fetchFromGitHub {
      owner = "facebook";
      repo = "rocksdb";
      rev = "refs/tags/v7.9.2";
      hash = "sha256-5P7IqJ14EZzDkbjaBvbix04ceGGdlWBuVFH/5dpD5VM=";
    };
  };

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
    packageOverrides = self: super: let cryptographyOverrideVersion = "40.0.1"; in {
      # Ceph does not support `cryptography` > 40 yet:
      # * https://github.com/NixOS/nixpkgs/pull/281858#issuecomment-1899358602
      # * Upstream issue: https://tracker.ceph.com/issues/63529
      #   > Python Sub-Interpreter Model Used by ceph-mgr Incompatible With Python Modules Based on PyO3
      #
      # We pin the older `cryptography` 40 here;
      # this also forces us to pin an older `pyopenssl` because the current one
      # is not compatible with older `cryptography`, see:
      #     https://github.com/pyca/pyopenssl/blob/d9752e44127ba36041b045417af8a0bf16ec4f1e/CHANGELOG.rst#2320-2023-05-30
      cryptography = super.cryptography.overridePythonAttrs (old: rec {
        version = cryptographyOverrideVersion;

        src = fetchPypi {
          inherit (old) pname;
          version = cryptographyOverrideVersion;
          hash = "sha256-KAPy+LHpX2FEGZJsfm9V2CivxhTKXtYVQ4d65mjMNHI=";
        };

        cargoDeps = rustPlatform.fetchCargoTarball {
          inherit src;
          sourceRoot = let cargoRoot = "src/rust"; in "${old.pname}-${cryptographyOverrideVersion}/${cargoRoot}";
          name = "${old.pname}-${cryptographyOverrideVersion}";
          hash = "sha256-gFfDTc2QWBWHBCycVH1dYlCsWQMVcRZfOBIau+njtDU=";
        };

        patches = (old.patches or []) ++ [
          # Fix https://nvd.nist.gov/vuln/detail/CVE-2023-49083 which has no upstream backport.
          # See https://github.com/pyca/cryptography/commit/f09c261ca10a31fe41b1262306db7f8f1da0e48a#diff-f5134bf8f3cf0a5cc8601df55e50697acc866c603a38caff98802bd8e17976c5R1893
          ./python-cryptography-Cherry-pick-fix-for-CVE-2023-49083-on-cryptography-40.patch
        ];

        # Tests would require overriding `cryptography-vectors`, which is not currently
        # possible/desired, see: https://github.com/NixOS/nixpkgs/pull/281858#pullrequestreview-1841421866
        doCheck = false;
      });

      # This is the most recent version of `pyopenssl` that's still compatible with `cryptography` 40.
      # See https://github.com/NixOS/nixpkgs/pull/281858#issuecomment-1899358602
      pyopenssl = super.pyopenssl.overridePythonAttrs (old: rec {
        version = "23.1.1";
        src = fetchPypi {
          pname = "pyOpenSSL";
          inherit version;
          hash = "sha256-hBSYub7GFiOxtsR+u8AjZ8B9YODhlfGXkIF/EMyNsLc=";
        };
      });

      # Ceph does not support `kubernetes` >= 19, see:
      #     https://github.com/NixOS/nixpkgs/pull/281858#issuecomment-1900324090
      kubernetes = super.kubernetes.overridePythonAttrs (old: rec {
        version = "18.20.0";
        src = fetchFromGitHub {
          owner = "kubernetes-client";
          repo = "python";
          rev = "v${version}";
          sha256 = "1sawp62j7h0yksmg9jlv4ik9b9i1a1w9syywc9mv8x89wibf5ql1";
          fetchSubmodules = true;
        };
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
  inherit (ceph-python-env.python) sitePackages;

  version = "18.2.0";
  src = fetchurl {
    url = "https://download.ceph.com/tarballs/ceph-${version}.tar.gz";
    hash = "sha256:0k9nl6xi5brva51rr14m7ig27mmmd7vrpchcmqc40q3c2khn6ns9";
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
      nasm
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
      cryptsetup
      cunit
      gperf
      gtest
      icu
      libcap
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
      libcap_ng
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

    # replace /sbin and /bin based paths with direct nix store paths
    # increase the `command` buffer size since 2 nix store paths cannot fit within 128 characters
    preConfigure =''
      substituteInPlace src/common/module.c \
        --replace "char command[128];" "char command[256];" \
        --replace "/sbin/modinfo"  "${kmod}/bin/modinfo" \
        --replace "/sbin/modprobe" "${kmod}/bin/modprobe" \
        --replace "/bin/grep" "${gnugrep}/bin/grep"

      # install target needs to be in PYTHONPATH for "*.pth support" check to succeed
      # set PYTHONPATH, so the build system doesn't silently skip installing ceph-volume and others
      export PYTHONPATH=${ceph-python-env}/${sitePackages}:$lib/${sitePackages}:$out/${sitePackages}
      patchShebangs src/
    '';

    cmakeFlags = [
      "-DCMAKE_INSTALL_DATADIR=${placeholder "lib"}/lib"

      "-DWITH_CEPHFS_SHELL:BOOL=ON"
      "-DWITH_SYSTEMD:BOOL=OFF"
      # `WITH_JAEGER` requires `thrift` as a depenedncy (fine), but the build fails with:
      #     CMake Error at src/opentelemetry-cpp-stamp/opentelemetry-cpp-build-Release.cmake:49 (message):
      #     Command failed: 2
      #
      #        'make' 'opentelemetry_trace' 'opentelemetry_exporter_jaeger_trace'
      #
      #     See also
      #
      #        /build/ceph-18.2.0/build/src/opentelemetry-cpp/src/opentelemetry-cpp-stamp/opentelemetry-cpp-build-*.log
      # and that file contains:
      #     /build/ceph-18.2.0/src/jaegertracing/opentelemetry-cpp/exporters/jaeger/src/TUDPTransport.cc: In member function 'virtual void opentelemetry::v1::exporter::jaeger::TUDPTransport::close()':
      #     /build/ceph-18.2.0/src/jaegertracing/opentelemetry-cpp/exporters/jaeger/src/TUDPTransport.cc:71:7: error: '::close' has not been declared; did you mean 'pclose'?
      #       71 |     ::THRIFT_CLOSESOCKET(socket_);
      #          |       ^~~~~~~~~~~~~~~~~~
      # Looks like `close()` is somehow not included.
      # But the relevant code is already removed in `open-telemetry` 1.10: https://github.com/open-telemetry/opentelemetry-cpp/pull/2031
      # So it's proably not worth trying to fix that for this Ceph version,
      # and instead just disable Ceph's Jaeger support.
      "-DWITH_JAEGER:BOOL=OFF"
      "-DWITH_TESTS:BOOL=OFF"

      # Use our own libraries, where possible
      "-DWITH_SYSTEM_ARROW:BOOL=ON" # Only used if other options enable Arrow support.
      "-DWITH_SYSTEM_BOOST:BOOL=ON"
      "-DWITH_SYSTEM_GTEST:BOOL=ON"
      "-DWITH_SYSTEM_ROCKSDB:BOOL=ON"
      "-DWITH_SYSTEM_UTF8PROC:BOOL=ON"
      "-DWITH_SYSTEM_ZSTD:BOOL=ON"

      # TODO breaks with sandbox, tries to download stuff with npm
      "-DWITH_MGR_DASHBOARD_FRONTEND:BOOL=OFF"
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
