{
  lib,
  stdenv,
  runCommand,
  fetchurl,
  fetchFromGitHub,
  fetchPypi,
  fetchpatch2,

  # Build time
  autoconf,
  automake,
  cmake,
  ensureNewerSourcesHook,
  fmt,
  git,
  libtool,
  makeWrapper,
  nasm,
  pkg-config,
  which,
  openssl,

  # Tests
  nixosTests,

  # Runtime dependencies
  arrow-cpp,
  babeltrace,
  # Note when trying to upgrade boost:
  # * When upgrading Ceph, it's recommended to check which boost version Ceph uses on Fedora,
  #   and default to that.
  # * The version that Ceph downloads if `-DWITH_SYSTEM_BOOST:BOOL=ON` is not given
  #   is declared in `cmake/modules/BuildBoost.cmake` line `set(boost_version ...)`.
  #
  # If you want to upgrade to boost >= 1.86, you need a Ceph version that
  # has this PR in:
  #     https://github.com/ceph/ceph/pull/61312
  boost183,
  bzip2,
  cryptsetup,
  cunit,
  e2fsprogs,
  doxygen,
  gperf,
  graphviz,
  gnugrep,
  gtest,
  icu,
  kmod,
  libcap,
  libcap_ng,
  libnbd,
  libnl,
  libxml2,
  lmdb,
  lttng-ust,
  lua,
  lvm2,
  lz4,
  oath-toolkit,
  openldap,
  parted,
  python311, # to get an idea which Python versions are supported by Ceph, see upstream `do_cmake.sh` (see `PYBUILD=` variable)
  rdkafka,
  rocksdb,
  snappy,
  openssh,
  sqlite,
  utf8proc,
  xfsprogs,
  zlib,
  zstd,

  # Dependencies of overridden Python dependencies, hopefully we can remove these soon.
  rustPlatform,

  # Optional Dependencies
  curl ? null,
  expat ? null,
  fuse ? null,
  libatomic_ops ? null,
  libedit ? null,
  libs3 ? null,
  yasm ? null,

  # Mallocs
  gperftools ? null,
  jemalloc ? null,

  # Crypto Dependencies
  cryptopp ? null,
  nspr ? null,
  nss ? null,

  # Linux Only Dependencies
  linuxHeaders,
  util-linux,
  libuuid,
  udev,
  keyutils,
  rdma-core,
  rabbitmq-c,
  libaio ? null,
  libxfs ? null,
  liburing ? null,
  zfs ? null,
  ...
}:

# We must have one crypto library
assert cryptopp != null || (nss != null && nspr != null);

let
  shouldUsePkg =
    pkg: if pkg != null && lib.meta.availableOn stdenv.hostPlatform pkg then pkg else null;

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
  cryptoStr =
    if optNss != null && optNspr != null then
      "nss"
    else if optCryptopp != null then
      "cryptopp"
    else
      "none";

  cryptoLibsMap = {
    nss = [
      optNss
      optNspr
    ];
    cryptopp = [ optCryptopp ];
    none = [ ];
  };

  getMeta = description: {
    homepage = "https://ceph.io/en/";
    inherit description;
    license = with lib.licenses; [
      lgpl21
      gpl2Only
      bsd3
      mit
      publicDomain
    ];
    maintainers = with lib.maintainers; [
      adev
      ak
      johanot
      krav
      nh2
      benaryorg
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };

  ceph-common =
    with python.pkgs;
    buildPythonPackage {
      pname = "ceph-common";
      format = "setuptools";
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
    packageOverrides =
      self: super:
      let
        bcryptOverrideVersion = "4.0.1";
      in
      {
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
          cargoDeps = rustPlatform.fetchCargoVendor {
            inherit
              pname
              version
              src
              cargoRoot
              ;
            hash = "sha256-8PyCgh/rUO8uynzGdgylAsb5k55dP9fCnf40UOTCR/M=";
          };
        });

        # We pin the older `cryptography` 40 here;
        # this also forces us to pin other packages, see below
        cryptography = self.callPackage ./old-python-packages/cryptography.nix { };

        # This is the most recent version of `pyopenssl` that's still compatible with `cryptography` 40.
        # See https://github.com/NixOS/nixpkgs/pull/281858#issuecomment-1899358602
        # and https://github.com/pyca/pyopenssl/blob/d9752e44127ba36041b045417af8a0bf16ec4f1e/CHANGELOG.rst#2320-2023-05-30
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
          disabledTestPaths = old.disabledTestPaths or [ ] ++ [
            "tests/test_ssl.py"
          ];
          propagatedBuildInputs = old.propagatedBuildInputs or [ ] ++ [
            self.flaky
          ];
          # hack: avoid building docs due to incompatibility with current sphinx
          nativeBuildInputs = [ openssl ]; # old.nativeBuildInputs but without sphinx*
          outputs = lib.filter (o: o != "doc") old.outputs;
        });

        # This is the most recent version of `trustme` that's still compatible with `cryptography` 40.
        # See https://github.com/NixOS/nixpkgs/issues/359723
        # and https://github.com/python-trio/trustme/commit/586f7759d5c27beb44da60615a71848eb2a5a490
        trustme = self.callPackage ./old-python-packages/trustme.nix { };

        fastapi = super.fastapi.overridePythonAttrs (old: {
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

  boost' = boost183.override {
    enablePython = true;
    inherit python;
  };

  # TODO: split this off in build and runtime environment
  ceph-python-env = python.withPackages (
    ps: with ps; [
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

      # src/cephadm/zipapp-reqs.txt
      markupsafe

      # src/pybind/mgr/requirements-required.txt
      cryptography
      jsonpatch

      # src/tools/cephfs/shell/setup.py
      cmd2
      colorama
    ]
  );
  inherit (ceph-python-env.python) sitePackages;

  version = "19.2.3";
  src = fetchurl {
    url = "https://download.ceph.com/tarballs/ceph-${version}.tar.gz";
    hash = "sha256-zlgp28C81SZbaFJ4yvQk4ZgYz4K/aZqtcISTO8LscSU=";
  };
in
rec {
  ceph = stdenv.mkDerivation {
    pname = "ceph";
    inherit src version;

    patches = [
      ./boost-1.85.patch

      (fetchpatch2 {
        name = "ceph-boost-1.86-uuid.patch";
        url = "https://github.com/ceph/ceph/commit/01306208eac492ee0e67bff143fc32d0551a2a6f.patch?full_index=1";
        hash = "sha256-OnDrr72inzGXXYxPFQevsRZImSvI0uuqFHqtFU2dPQE=";
      })

      # See:
      # * <https://github.com/boostorg/python/issues/394>
      # * <https://aur.archlinux.org/cgit/aur.git/commit/?h=ceph&id=8c5cc7d8deec002f7596b6d0860859a0a718f12b>
      # * <https://github.com/ceph/ceph/pull/60999>
      ./boost-1.86-PyModule.patch
    ];

    nativeBuildInputs = [
      autoconf # `autoreconf` is called, e.g. for `qatlib_ext`
      automake # `aclocal` is called, e.g. for `qatlib_ext`
      cmake
      fmt
      git
      makeWrapper
      libtool # used e.g. for `qatlib_ext`
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

    buildInputs =
      cryptoLibsMap.${cryptoStr}
      ++ [
        arrow-cpp
        babeltrace
        boost'
        bzip2
        # Adding `ceph-python-env` here adds the env's `site-packages` to `PYTHONPATH` during the build.
        # This is important, otherwise the build system may not find the Python deps and then
        # silently skip installing ceph-volume and other Ceph python tools.
        ceph-python-env
        cryptsetup
        cunit
        e2fsprogs # according to `debian/control` file, `ceph-volume` is supposed to use it
        gperf
        gtest
        icu
        libcap
        libnbd
        libnl
        libxml2
        lmdb
        lttng-ust
        lua
        lvm2 # according to `debian/control` file, e.g. `pvs` command used by `src/ceph-volume/ceph_volume/api/lvm.py`
        lz4
        malloc
        oath-toolkit
        openldap
        optLibatomic_ops
        optLibs3
        optYasm
        parted # according to `debian/control` file, used by `src/ceph-volume/ceph_volume/util/disk.py`
        rdkafka
        rocksdb'
        snappy
        openssh # according to `debian/control` file, `ssh` command used by `cephadm`
        sqlite
        utf8proc
        xfsprogs # according to `debian/control` file, `ceph-volume` is supposed to use it
        zlib
        zstd
      ]
      ++ lib.optionals stdenv.hostPlatform.isLinux [
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
      ]
      ++ lib.optionals hasRadosgw [
        optCurl
        optExpat
        optFuse
        optLibedit
      ];

    # Picked up, amongst others, by `wrapPythonPrograms`.
    pythonPath = [
      ceph-python-env
      "${placeholder "out"}/${ceph-python-env.sitePackages}"
    ];

    # * `unset AS` because otherwise the Ceph CMake build errors with
    #       configure: error: No modern nasm or yasm found as required. Nasm should be v2.11.01 or later (v2.13 for AVX512) and yasm should be 1.2.0 or later.
    #   because the code at
    #       https://github.com/intel/isa-l/blob/633add1b569fe927bace3960d7c84ed9c1b38bb9/configure.ac#L99-L191
    #   doesn't even consider using `nasm` or `yasm` but instead uses `$AS`
    #   from `gcc-wrapper`.
    #   (Ceph's error message is extra confusing, because it says
    #   `No modern nasm or yasm found` when in fact it found e.g. `nasm`
    #   but then uses `$AS` instead.
    # * replace /sbin and /bin based paths with direct nix store paths
    # * increase the `command` buffer size since 2 nix store paths cannot fit within 128 characters
    preConfigure = ''
      unset AS

      substituteInPlace src/common/module.c \
        --replace "char command[128];" "char command[256];" \
        --replace "/sbin/modinfo"  "${kmod}/bin/modinfo" \
        --replace "/sbin/modprobe" "${kmod}/bin/modprobe" \
        --replace "/bin/grep" "${gnugrep}/bin/grep"

      # Patch remount to use full path to mount(8), otherwise ceph-fuse fails when run
      # from a systemd unit for example.
      substituteInPlace src/client/fuse_ll.cc \
        --replace-fail "mount -i -o remount" "${util-linux}/bin/mount -i -o remount"

      # The install target needs to be in PYTHONPATH for "*.pth support" check to succeed
      export PYTHONPATH=$PYTHONPATH:$lib/${sitePackages}:$out/${sitePackages}
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
      # So it's probably not worth trying to fix that for this Ceph version,
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

      # Use our own python libraries too, see:
      #     https://github.com/NixOS/nixpkgs/pull/344993#issuecomment-2391046329
      "-DCEPHADM_BUNDLED_DEPENDENCIES=none"

      # TODO breaks with sandbox, tries to download stuff with npm
      "-DWITH_MGR_DASHBOARD_FRONTEND:BOOL=OFF"
      # WITH_XFS has been set default ON from Ceph 16, keeping it optional in nixpkgs for now
      ''-DWITH_XFS=${if optLibxfs != null then "ON" else "OFF"}''
    ]
    ++ lib.optional stdenv.hostPlatform.isLinux "-DWITH_SYSTEM_LIBURING=ON";

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

    outputs = [
      "out"
      "lib"
      "dev"
      "doc"
      "man"
    ];

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
          ceph-single-node-bluestore-dmcrypt
          ;
      };
    };
  };

  ceph-client =
    runCommand "ceph-client-${version}"
      {
        meta = getMeta "Tools needed to mount Ceph's RADOS Block Devices/Cephfs";
      }
      ''
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
