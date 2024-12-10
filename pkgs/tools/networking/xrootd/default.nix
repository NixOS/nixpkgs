{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  davix,
  cmake,
  cppunit,
  gtest,
  makeWrapper,
  pkg-config,
  curl,
  fuse,
  libkrb5,
  libuuid,
  libxcrypt,
  libxml2,
  openssl,
  readline,
  scitokens-cpp,
  systemd,
  voms,
  zlib,
  # Build bin/test-runner
  enableTestRunner ? true,
  # If not null, the builder will
  # move "$out/etc" to "$out/etc.orig" and symlink "$out/etc" to externalEtc.
  externalEtc ? "/etc",
  removeReferencesTo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xrootd";
  version = "5.6.6";

  src = fetchFromGitHub {
    owner = "xrootd";
    repo = "xrootd";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-vSZKTsDMY5bhfniFOQ11VA30gjfb4Y8tCC7JNjNw8Y0=";
  };

  outputs = [
    "bin"
    "out"
    "dev"
    "man"
  ] ++ lib.optional (externalEtc != null) "etc";

  passthru.fetchxrd = callPackage ./fetchxrd.nix { xrootd = finalAttrs.finalPackage; };
  passthru.tests =
    lib.optionalAttrs stdenv.hostPlatform.isLinux {
      test-runner = callPackage ./test-runner.nix { xrootd = finalAttrs.finalPackage; };
    }
    // {
      test-xrdcp = finalAttrs.passthru.fetchxrd {
        pname = "xrootd-test-xrdcp";
        # Use the the bin output hash of xrootd as version to ensure that
        # the test gets rebuild everytime xrootd gets rebuild
        version =
          finalAttrs.version
          + "-"
          + builtins.substring (builtins.stringLength builtins.storeDir + 1) 32 "${finalAttrs.finalPackage}";
        url = "root://eospublic.cern.ch//eos/opendata/alice/2010/LHC10h/000138275/ESD/0000/AliESDs.root";
        hash = "sha256-tIcs2oi+8u/Qr+P7AAaPTbQT+DEt26gEdc4VNerlEHY=";
      };
    };

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
    removeReferencesTo
  ];

  buildInputs =
    [
      davix
      curl
      libkrb5
      libuuid
      libxcrypt
      libxml2
      openssl
      readline
      scitokens-cpp
      zlib
    ]
    ++ lib.optionals (!stdenv.isDarwin) [
      # https://github.com/xrootd/xrootd/blob/5b5a1f6957def2816b77ec773c7e1bfb3f1cfc5b/cmake/XRootDFindLibs.cmake#L58
      fuse
    ]
    ++ lib.optionals stdenv.isLinux [
      systemd
      voms
    ]
    ++ lib.optionals enableTestRunner [
      gtest
      cppunit
    ];

  preConfigure =
    ''
      patchShebangs genversion.sh
      substituteInPlace cmake/XRootDConfig.cmake.in \
        --replace-fail "@PACKAGE_CMAKE_INSTALL_" "@CMAKE_INSTALL_FULL_"
    ''
    + lib.optionalString stdenv.isDarwin ''
      sed -i cmake/XRootDOSDefs.cmake -e '/set( MacOSX TRUE )/ainclude( GNUInstallDirs )'
    '';

  # https://github.com/xrootd/xrootd/blob/master/packaging/rhel/xrootd.spec.in#L665-L675=
  postInstall =
    ''
      mkdir -p "$out/lib/tmpfiles.d"
      install -m 644 -T ../packaging/rhel/xrootd.tmpfiles "$out/lib/tmpfiles.d/xrootd.conf"
      mkdir -p "$out/etc/xrootd"
      install -m 644 -t "$out/etc/xrootd" ../packaging/common/*.cfg
      install -m 644 -t "$out/etc/xrootd" ../packaging/common/client.conf
      mkdir -p "$out/etc/xrootd/client.plugins.d"
      install -m 644 -t "$out/etc/xrootd/client.plugins.d" ../packaging/common/client-plugin.conf.example
      mkdir -p "$out/etc/logrotate.d"
      install -m 644 -T ../packaging/common/xrootd.logrotate "$out/etc/logrotate.d/xrootd"
    ''
    # Leaving those in bin/ leads to a cyclic reference between $dev and $bin
    # This happens since https://github.com/xrootd/xrootd/commit/fe268eb622e2192d54a4230cea54c41660bd5788
    # So far, this xrootd-config script does not seem necessary in $bin
    + ''
      moveToOutput "bin/xrootd-config" "$dev"
      moveToOutput "bin/.xrootd-config-wrapped" "$dev"
    ''
    + lib.optionalString stdenv.isLinux ''
      mkdir -p "$out/lib/systemd/system"
      install -m 644 -t "$out/lib/systemd/system" ../packaging/common/*.service ../packaging/common/*.socket
    '';

  cmakeFlags =
    [
      "-DXRootD_VERSION_STRING=${finalAttrs.version}"
    ]
    ++ lib.optionals enableTestRunner [
      "-DFORCE_ENABLED=TRUE"
      "-DENABLE_DAVIX=TRUE"
      "-DENABLE_FUSE=${if (!stdenv.isDarwin) then "TRUE" else "FALSE"}" # not supported
      "-DENABLE_MACAROONS=OFF"
      "-DENABLE_PYTHON=FALSE" # built separately
      "-DENABLE_SCITOKENS=TRUE"
      "-DENABLE_TESTS=TRUE"
      "-DENABLE_VOMS=${if stdenv.isLinux then "TRUE" else "FALSE"}"
    ];

  postFixup = lib.optionalString (externalEtc != null) ''
    moveToOutput etc "$etc"
    ln -s ${lib.escapeShellArg externalEtc} "$out/etc"
  '';

  dontPatchELF = true; # shrinking rpath will cause runtime failures in dlopen

  meta = with lib; {
    description = "High performance, scalable fault tolerant data access";
    homepage = "https://xrootd.slac.stanford.edu";
    license = licenses.lgpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ ShamrockLee ];
  };
})
