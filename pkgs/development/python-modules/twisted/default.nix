{
  lib,
  stdenv,
  buildPythonPackage,
  pythonAtLeast,
  pythonOlder,
  fetchPypi,
  python,

  # build-system
  hatchling,
  hatch-fancy-pypi-readme,

  # dependencies
  attrs,
  automat,
  constantly,
  hyperlink,
  incremental,
  typing-extensions,
  zope-interface,

  # optional-dependencies
  appdirs,
  bcrypt,
  cryptography,
  h2,
  idna,
  priority,
  pyopenssl,
  pyserial,
  service-identity,

  # tests
  cython-test-exception-raiser,
  git,
  glibcLocales,
  pyhamcrest,
  hypothesis,

  # for passthru.tests
  cassandra-driver,
  httpx,
  klein,
  magic-wormhole,
  scrapy,
  treq,
  txaio,
  txamqp,
  txrequests,
  txtorcon,
  thrift,
  nixosTests,
}:

buildPythonPackage rec {
  pname = "twisted";
  version = "24.10.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    extension = "tar.gz";
    hash = "sha256-ApUSmWcllf6g9w+i1fe149VoNhV+2miFmmrWSS02dW4=";
  };

  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [
    hatchling
    hatch-fancy-pypi-readme
    incremental
  ];

  propagatedBuildInputs = [
    attrs
    automat
    constantly
    hyperlink
    incremental
    typing-extensions
    zope-interface
  ];

  postPatch =
    let
      skippedTests =
        {
          "src/twisted/conch/test/test_cftp.py" = [
            # timezone issues
            "ListingTests.test_localeIndependent"
            "ListingTests.test_newSingleDigitDayOfMonth"
            "ListingTests.test_oldFile"
            "ListingTests.test_oldSingleDigitDayOfMonth"
            "ListingTests.test_newFile"
          ];
          "src/twisted/test/test_log.py" = [
            # wrong timezone offset calculation
            "FileObserverTests.test_getTimezoneOffsetEastOfUTC"
            "FileObserverTests.test_getTimezoneOffsetWestOfUTC"
            "FileObserverTests.test_getTimezoneOffsetWithoutDaylightSavingTime"
          ];
          "src/twisted/test/test_udp.py" = [
            # "No such device" (No multicast support in the build sandbox)
            "MulticastTests.test_joinLeave"
            "MulticastTests.test_loopback"
            "MulticastTests.test_multicast"
            "MulticastTests.test_multiListen"
          ];
          "src/twisted/internet/test/test_unix.py" = [
            # flaky?
            "UNIXTestsBuilder.test_sendFileDescriptorTriggersPauseProducing"
          ];
        }
        // lib.optionalAttrs (pythonAtLeast "3.12") {
          "src/twisted/trial/_dist/test/test_workerreporter.py" = [
            "WorkerReporterTests.test_addSkipPyunit"
          ];
          "src/twisted/trial/_dist/test/test_worker.py" = [
            "LocalWorkerAMPTests.test_runSkip"
          ];
        }
        // lib.optionalAttrs (pythonOlder "3.13") {
          # missing ciphers in the crypt module due to libxcrypt
          "src/twisted/web/test/test_tap.py" = [
            "ServiceTests.test_HTTPSFailureOnMissingSSL"
            "ServiceTests.test_HTTPSFailureOnMissingSSL"
          ];
          "src/twisted/conch/test/test_checkers.py" = [
            "HelperTests.test_refuteCryptedPassword"
            "HelperTests.test_verifyCryptedPassword"
            "HelperTests.test_verifyCryptedPasswordMD5"
            "UNIXPasswordDatabaseTests.test_defaultCheckers"
            "UNIXPasswordDatabaseTests.test_passInCheckers"
          ];
          "src/twisted/cred/test/test_strcred.py" = [
            "UnixCheckerTests.test_isChecker"
            "UnixCheckerTests.test_unixCheckerFailsPassword"
            "UnixCheckerTests.test_unixCheckerFailsPasswordBytes"
            "UnixCheckerTests.test_unixCheckerFailsUsername"
            "UnixCheckerTests.test_unixCheckerFailsUsernameBytes"
            "UnixCheckerTests.test_unixCheckerSucceeds"
            "UnixCheckerTests.test_unixCheckerSucceedsBytes"
            "CryptTests.test_verifyCryptedPassword"
            "CryptTests.test_verifyCryptedPasswordOSError"
          ];
          # dependant on UnixCheckerTests.test_isChecker
          "src/twisted/cred/test/test_cred.py" = [
            "HashedPasswordOnDiskDatabaseTests.testBadCredentials"
            "HashedPasswordOnDiskDatabaseTests.testGoodCredentials"
            "HashedPasswordOnDiskDatabaseTests.testGoodCredentials_login"
            "HashedPasswordOnDiskDatabaseTests.testHashedCredentials"
          ];
        }
        // lib.optionalAttrs (pythonAtLeast "3.13") {
          "src/twisted/web/test/test_flatten.py" = [
            "FlattenerErrorTests.test_asynchronousFlattenError"
            "FlattenerErrorTests.test_cancel"
          ];
        }
        // lib.optionalAttrs stdenv.hostPlatform.isDarwin {
          "src/twisted/internet/test/test_process.py" = [
            # invalid syntaax
            "ProcessTestsBuilder_AsyncioSelectorReactorTests.test_openFileDescriptors"
            "ProcessTestsBuilder_SelectReactorTests.test_openFileDescriptors"
            # exit code 120
            "ProcessTestsBuilder_AsyncioSelectorReactorTests.test_processEnded"
            "ProcessTestsBuilder_SelectReactorTests.test_processEnded"
          ];
        };
    in
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList (
        file: tests: lib.concatMapStringsSep "\n" (test: ''echo '${test}.skip = ""' >> "${file}"'') tests
      ) skippedTests
    )
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      # Patch t.p._inotify to point to libc. Without this,
      # twisted.python.runtime.platform.supportsINotify() == False
      substituteInPlace src/twisted/python/_inotify.py --replace-fail \
        "ctypes.util.find_library(\"c\")" "'${stdenv.cc.libc}/lib/libc.so.6'"
    '';

  # Generate Twisted's plug-in cache. Twisted users must do it as well. See
  # http://twistedmatrix.com/documents/current/core/howto/plugin.html#auto3
  # and http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=477103 for details.
  postFixup = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    $out/bin/twistd --help > /dev/null
  '';

  nativeCheckInputs =
    [
      git
      glibcLocales
    ]
    ++ optional-dependencies.test
    ++ optional-dependencies.conch
    ++ optional-dependencies.http2
    ++ optional-dependencies.serial
    ++ optional-dependencies.tls;

  preCheck = ''
    export SOURCE_DATE_EPOCH=315532800
    export PATH=$out/bin:$PATH
  '';

  checkPhase = ''
    runHook preCheck
    # race conditions when running in paralell
    ${python.interpreter} -m twisted.trial -j1 twisted
    runHook postCheck
  '';

  optional-dependencies = {
    conch = [
      appdirs
      bcrypt
      cryptography
    ];
    http2 = [
      h2
      priority
    ];
    serial = [ pyserial ];
    test = [
      cython-test-exception-raiser
      pyhamcrest
      hypothesis
      httpx
    ] ++ httpx.optional-dependencies.http2;
    tls = [
      idna
      pyopenssl
      service-identity
    ];
  };

  passthru = {
    tests = {
      inherit
        cassandra-driver
        klein
        magic-wormhole
        scrapy
        treq
        txaio
        txamqp
        txrequests
        txtorcon
        thrift
        ;
      inherit (nixosTests) buildbot matrix-synapse;
    };
  };

  meta = with lib; {
    changelog = "https://github.com/twisted/twisted/blob/twisted-${version}/NEWS.rst";
    homepage = "https://github.com/twisted/twisted";
    description = "Asynchronous networking framework written in Python";
    license = licenses.mit;
    maintainers = [ ];
  };
}
