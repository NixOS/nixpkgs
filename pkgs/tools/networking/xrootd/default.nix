{ lib
, stdenv
, callPackage
, fetchFromGitHub
, cmake
, cppunit
, makeWrapper
, pkg-config
, curl
, fuse
, libkrb5
, libuuid
, libxcrypt
, libxml2
, openssl
, readline
, systemd
, voms
, zlib
  # Build bin/test-runner
, enableTestRunner ? true
  # If not null, the builder will
  # move "$out/etc" to "$out/etc.orig" and symlink "$out/etc" to externalEtc.
, externalEtc ? "/etc"
}:

stdenv.mkDerivation (finalAttrs: {

  __structuredAttrs = true;

  pname = "xrootd";
  version = "5.5.5";

  src = fetchFromGitHub {
    owner = "xrootd";
    repo = "xrootd";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-SLmxv8opN7z4V07S9kLGo8HG7Ql62iZQLtf3zGemwA8=";
  };

  outputs = [ "bin" "out" "dev" "man" ]
  ++ lib.optional (externalEtc != null) "etc";

  passthru.fetchxrd = callPackage ./fetchxrd.nix { xrootd = finalAttrs.finalPackage; };
  passthru.tests =
    lib.optionalAttrs stdenv.hostPlatform.isLinux {
      test-runner = callPackage ./test-runner.nix { xrootd = finalAttrs.finalPackage; };
    } // {
    test-xrdcp = finalAttrs.passthru.fetchxrd {
      pname = "xrootd-test-xrdcp";
      # Use the the bin output hash of xrootd as version to ensure that
      # the test gets rebuild everytime xrootd gets rebuild
      version = finalAttrs.version + "-" + builtins.substring (builtins.stringLength builtins.storeDir + 1) 32 "${finalAttrs.finalPackage}";
      url = "root://eospublic.cern.ch//eos/opendata/alice/2010/LHC10h/000138275/ESD/0000/AliESDs.root";
      hash = "sha256-tIcs2oi+8u/Qr+P7AAaPTbQT+DEt26gEdc4VNerlEHY=";
    };
  }
  ;

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    curl
    libkrb5
    libuuid
    libxcrypt
    libxml2
    openssl
    readline
    zlib
    fuse
  ]
  ++ lib.optionals stdenv.isLinux [
    systemd
    voms
  ]
  ++ lib.optionals enableTestRunner [
    cppunit
  ];

  preConfigure = ''
    patchShebangs genversion.sh
  '';

  # https://github.com/xrootd/xrootd/blob/master/packaging/rhel/xrootd.spec.in#L665-L675=
  postInstall = ''
    mkdir -p "$out/lib/tmpfiles.d"
    install -m 644 -T ../packaging/rhel/xrootd.tmpfiles "$out/lib/tmpfiles.d/xrootd.conf"
    mkdir -p "$out/etc/xrootd"
    install -m 644 -t "$out/etc/xrootd" ../packaging/common/*.cfg
    install -m 644 -t "$out/etc/xrootd" ../packaging/common/client.conf
    mkdir -p "$out/etc/xrootd/client.plugins.d"
    install -m 644 -t "$out/etc/xrootd/client.plugins.d" ../packaging/common/client-plugin.conf.example
    mkdir -p "$out/etc/logrotate.d"
    install -m 644 -T ../packaging/common/xrootd.logrotate "$out/etc/logrotate.d/xrootd"
  '' + lib.optionalString stdenv.isLinux ''
    mkdir -p "$out/lib/systemd/system"
    install -m 644 -t "$out/lib/systemd/system" ../packaging/common/*.service ../packaging/common/*.socket
  '';

  cmakeFlags = lib.optionals enableTestRunner [
    "-DENABLE_TESTS=TRUE"
  ];

  makeWrapperArgs = [
    # Workaround the library-not-found issue
    # happening to binaries compiled with xrootd libraries.
    # See #169677
    "--prefix" "${lib.optionalString stdenv.hostPlatform.isDarwin "DY"}LD_LIBRARY_PATH" ":" "${placeholder "out"}/lib"
  ];

  postFixup = ''
    while IFS= read -r FILE; do
      wrapProgram "$FILE" "''${makeWrapperArgs[@]}"
    done < <(find "$bin/bin" -mindepth 1 -maxdepth 1 -type f,l -perm -a+x)
  '' + lib.optionalString (externalEtc != null) ''
    moveToOutput etc "$etc"
    ln -s ${lib.escapeShellArg externalEtc} "$out/etc"
  '';

  meta = with lib; {
    description = "High performance, scalable fault tolerant data access";
    homepage = "https://xrootd.slac.stanford.edu";
    license = licenses.lgpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ ShamrockLee ];
  };
})
