{ lib
, stdenv
, runCommand
, fetchurl
, fetchFromGitHub
, fetchPypi
, fetchpatch

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
, python311
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

  getMeta = description: {
     homepage = "https://ceph.io/en/";
     inherit description;
     license = with lib.licenses; [ lgpl21 gpl2Only bsd3 mit publicDomain ];
     maintainers = with lib.maintainers; [ adev ak johanot krav nh2 ];
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
  python = python311.override {
    self = python;
    packageOverrides = self: super: let
      bcryptOverrideVersion = "4.0.1";
    in {
      # Ceph does not support the following yet:
      # * `bcrypt` > 4.0
      # * `cryptography` > 40
      # See:
      # * https://github.com/NixOS/nixpkgs/pull/281858#issuecomment-1899358602
      # * Upstream issue: https://tracker.ceph.com/issues/63529
      #   > Python Sub-Interpreter Model Used by ceph-mgr Incompatible With Python Modules Based on PyO3
      # * Moved to issue: https://tracker.ceph.com/issues/64213
      #   > MGR modules incompatible with later PyO3 versions - PyO3 modules may only be initialized once per interpreter process

      bcrypt = super.bcrypt.overridePythonAttrs (old: rec {
        pname = "bcrypt";
        version = bcryptOverrideVersion;
        src = fetchPypi {
          inherit pname version;
          hash = "sha256-J9N1kDrIJhz+QEf2cJ0W99GNObHskqr3KvmJVSplDr0=";
        };
        cargoRoot = "src/_bcrypt";
        cargoDeps = rustPlatform.fetchCargoTarball {
          inherit src;
          sourceRoot = "${pname}-${version}/${cargoRoot}";
          name = "${pname}-${version}";
          hash = "sha256-lDWX69YENZFMu7pyBmavUZaalGvFqbHSHfkwkzmDQaY=";
        };
      });

      # We pin the older `cryptography` 40 here;
      # this also forces us to pin an older `pyopenssl` because the current one
      # is not compatible with older `cryptography`, see:
      #     https://github.com/pyca/pyopenssl/blob/d9752e44127ba36041b045417af8a0bf16ec4f1e/CHANGELOG.rst#2320-2023-05-30
      cryptography = self.callPackage ./old-python-packages/cryptography.nix {};

      # This is the most recent version of `pyopenssl` that's still compatible with `cryptography` 40.
      # See https://github.com/NixOS/nixpkgs/pull/281858#issuecomment-1899358602
      pyopenssl = super.pyopenssl.overridePythonAttrs (old: rec {
        version = "23.1.1";
        src = fetchPypi {
          pname = "pyOpenSSL";
          inherit version;
          hash = "sha256-hBSYub7GFiOxtsR+u8AjZ8B9YODhlfGXkIF/EMyNsLc=";
        };
        disabledTests = old.disabledTests or [ ] ++ [
          "test_export_md5_digest"
        ];
        propagatedBuildInputs = old.propagatedBuildInputs or [ ] ++ [
          self.flaky
        ];
      });


      fastapi = super.fastapi.overridePythonAttrs (old: rec {
        # Flaky test:
        #     ResourceWarning: Unclosed <MemoryObjectSendStream>
        # Unclear whether it's flaky in general or only in this overridden package set.
        doCheck = false;
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
    cython_0

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

  version = "18.2.4";
  src = fetchurl {
    url = "https://download.ceph.com/tarballs/ceph-${version}.tar.gz";
    hash = "sha256-EFqteP3Jo+hASXVesH6gkjDjFO7/1RN151tIf/lQ06s=";
  };
in rec {
  ceph = stdenv.mkDerivation {
    pname = "ceph";
    inherit src version;

    patches = [
      # Fixes mgr not being able to import `packaging` due to autotools >= 70.
      # Remove once https://github.com/ceph/ceph/pull/58624 is merged, see
      # https://github.com/NixOS/nixpkgs/pull/330226#issuecomment-2268421031
      (fetchpatch {
        url = "https://github.com/ceph/ceph/commit/8da2d857fa8fdfedd7aad0ca90e1780a3ed085c9.patch";
        name = "ceph-mgr-python-fix-packaging-import.patch";
        hash = "sha256-3Yl1X6UfTf0XCXJxgRnM/Js9sz8tS+hsqViY6gDExoI=";
      })

      # Fixes cryptesetup version parsing regex, see
      # * https://github.com/NixOS/nixpkgs/issues/334227
      # * https://www.mail-archive.com/ceph-users@ceph.io/msg26309.html
      # * https://github.com/ceph/ceph/pull/58997
      # Remove once we're on the next version of Ceph 18, when this should be in:
      # https://github.com/ceph/ceph/pull/58997
      (fetchpatch {
        url = "https://github.com/ceph/ceph/commit/6ae874902b63652fa199563b6e7950cd75151304.patch";
        name = "ceph-reef-ceph-volume-fix-set_dmcrypt_no_workqueue.patch";
        hash = "sha256-r+7hcCz2WF/rJfgKwTatKY9unJlE8Uw3fmOyaY5jVH0=";
      })
      (fetchpatch {
        url = "https://github.com/ceph/ceph/commit/607eb34b2c278566c386efcbf3018629cf08ccfd.patch";
        name = "ceph-volume-fix-set_dmcrypt_no_workqueue-regex.patch";
        hash = "sha256-q28Q7OIyFoMyMBCPXGA+AdNqp+9/6J/XwD4ODjx+JXY=";
      })
    ];

    postPatch = ''
      substituteInPlace cmake/modules/Finduring.cmake \
        --replace-fail "liburing.a liburing" "uring"
    '';

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
    ] ++ lib.optionals stdenv.hostPlatform.isLinux [
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
    ] ++ lib.optional stdenv.hostPlatform.isLinux "-DWITH_SYSTEM_LIBURING=ON";

    preBuild =
      # The legacy-option-headers target is not correctly empbedded in the build graph.
      # It also contains some internal race conditions that we work around by building with `-j 1`.
      # Upstream discussion for additional context at https://tracker.ceph.com/issues/63402.
      ''
        cmake --build . --target legacy-option-headers -j 1
      '';

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
      inherit python; # to be able to test our overridden packages above individually with `nix-build -A`
      tests = {
        inherit (nixosTests)
          ceph-multi-node
          ceph-single-node
          ceph-single-node-bluestore
          ceph-single-node-bluestore-dmcrypt;
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
