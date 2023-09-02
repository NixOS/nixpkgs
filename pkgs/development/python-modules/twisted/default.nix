{ lib
, stdenv
, appdirs
, attrs
, automat
, bcrypt
, buildPythonPackage
, constantly
, cryptography
, fetchpatch
, fetchPypi
, git
, glibcLocales
, h2
, hatch-fancy-pypi-readme
, hatchling
, hyperlink
, hypothesis
, idna
, incremental
, priority
, pyhamcrest
, pynacl
, pyopenssl
, pyserial
, python
, pythonAtLeast
, pythonOlder
, service-identity
, setuptools
, typing-extensions
, zope_interface

  # for passthru.tests
, cassandra-driver
, klein
, magic-wormhole
, scrapy
, treq
, txaio
, txamqp
, txrequests
, txtorcon
, thrift
, nixosTests
}:

buildPythonPackage rec {
  pname = "twisted";
  version = "23.8.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PHM2Ct0XM2piLA2BHCos4phmtuWbESX9ZQmxclIJiiQ=";
  };

  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [
    hatch-fancy-pypi-readme
    hatchling
    incremental
  ];

  propagatedBuildInputs = [
    attrs
    automat
    constantly
    hyperlink
    incremental
    setuptools
    typing-extensions
    zope_interface
  ];

  postPatch = ''
    echo 'ListingTests.test_localeIndependent.skip = "Timezone issue"' >> src/twisted/conch/test/test_cftp.py
    echo 'ListingTests.test_newFile.skip = "Timezone issue" '>> src/twisted/conch/test/test_cftp.py
    echo 'ListingTests.test_newSingleDigitDayOfMonth.skip = "Timezone issue"' >> src/twisted/conch/test/test_cftp.py
    echo 'ListingTests.test_oldFile.skip = "Timezone issue"' >> src/twisted/conch/test/test_cftp.py
    echo 'ListingTests.test_oldSingleDigitDayOfMonth.skip = "Timezone issue"' >> src/twisted/conch/test/test_cftp.py

    echo 'WrapClientTLSParserTests.test_tls.skip = "pyopenssl update"' >> src/twisted/internet/test/test_endpoints.py
    echo 'UNIXTestsBuilder_AsyncioSelectorReactorTests.test_sendFileDescriptorTriggersPauseProducing.skip = "sendFileDescriptor producer was not paused"' >> src/twisted/internet/test/test_unix.py
    echo 'UNIXTestsBuilder_SelectReactorTests.test_sendFileDescriptorTriggersPauseProducing.skip = "sendFileDescriptor producer was not paused"' >> src/twisted/internet/test/test_unix.py

    echo 'FileObserverTests.test_getTimezoneOffsetEastOfUTC.skip = "mktime argument out of range"' >> src/twisted/test/test_log.py
    echo 'FileObserverTests.test_getTimezoneOffsetWestOfUTC.skip = "mktime argument out of range"' >> src/twisted/test/test_log.py
    echo 'FileObserverTests.test_getTimezoneOffsetWithoutDaylightSavingTime.skip = "tuple differs, values not"' >> src/twisted/test/test_log.py

    # Timestamp is not an exact match
    echo 'EventAsTextTests.test_eventAsTextTimestampOnly.skip = "Timestamp differs"' >> src/twisted/logger/test/test_format.py
    echo 'ClassicLogFormattingTests.test_formatTimeDefault.skip = "Timestamp differs"' >> src/twisted/logger/test/test_format.py
    echo 'TimeFormattingTests.test_formatTimeWithDefaultFormat.skip = "Timestamp differs"' >> src/twisted/logger/test/test_format.py

    echo 'MulticastTests.test_joinLeave.skip = "No such device"' >> src/twisted/test/test_udp.py
    echo 'MulticastTests.test_loopback.skip = "No such device"' >> src/twisted/test/test_udp.py
    echo 'MulticastTests.test_multicast.skip = "Reactor was unclean"' >> src/twisted/test/test_udp.py
    echo 'MulticastTests.test_multiListen.skip = "No such device"' >> src/twisted/test/test_udp.py

    # Tests fail since migrating to libxcrypt
    echo 'CryptTests.test_verifyCryptedPassword.skip = "builtins.OSError: [Errno 22] Invalid argument"' >> src/twisted/cred/test/test_strcred.py
    echo 'CryptTests.test_verifyCryptedPasswordOSError.skip = "builtins.OSError: [Errno 22] Invalid argument"' >> src/twisted/cred/test/test_strcred.py
    echo 'HashedPasswordOnDiskDatabaseTests.testBadCredentials.skip = "builtins.OSError: [Errno 22] Invalid argument"' >> src/twisted/cred/test/test_cred.py
    echo 'HashedPasswordOnDiskDatabaseTests.testGoodCredentials_login.skip = "builtins.OSError: [Errno 22] Invalid argument"' >> src/twisted/cred/test/test_cred.py
    echo 'HashedPasswordOnDiskDatabaseTests.testGoodCredentials.skip = "builtins.OSError: [Errno 22] Invalid argument"' >> src/twisted/cred/test/test_cred.py
    echo 'HashedPasswordOnDiskDatabaseTests.testHashedCredentials.skip = "builtins.OSError: [Errno 22] Invalid argument"' >> src/twisted/cred/test/test_cred.py
    echo 'HelperTests.test_refuteCryptedPassword.skip = "builtins.OSError: [Errno 22] Invalid argument"' >> src/twisted/conch/test/test_checkers.py
    echo 'HelperTests.test_verifyCryptedPassword.skip = "builtins.OSError: [Errno 22] Invalid argument"' >> src/twisted/conch/test/test_checkers.py
    echo 'HelperTests.test_verifyCryptedPasswordMD5.skip = "builtins.OSError: [Errno 22] Invalid argument"' >> src/twisted/conch/test/test_checkers.py
    echo 'UnixCheckerTests.test_isChecker.skip = "builtins.OSError: [Errno 22] Invalid argument"' >> src/twisted/cred/test/test_strcred.py
    echo 'UnixCheckerTests.test_unixCheckerFailsPassword.skip = "builtins.OSError: [Errno 22] Invalid argument"' >> src/twisted/cred/test/test_strcred.py
    echo 'UnixCheckerTests.test_unixCheckerFailsPasswordBytes.skip = "builtins.OSError: [Errno 22] Invalid argument"' >> src/twisted/cred/test/test_strcred.py
    echo 'UnixCheckerTests.test_unixCheckerFailsUsername.skip = "builtins.OSError: [Errno 22] Invalid argument"' >> src/twisted/cred/test/test_strcred.py
    echo 'UnixCheckerTests.test_unixCheckerFailsUsernameBytes.skip = "builtins.OSError: [Errno 22] Invalid argument"' >> src/twisted/cred/test/test_strcred.py
    echo 'UnixCheckerTests.test_unixCheckerSucceeds.skip = "builtins.OSError: [Errno 22] Invalid argument"' >> src/twisted/cred/test/test_strcred.py
    echo 'UnixCheckerTests.test_unixCheckerSucceedsBytes.skip = "builtins.OSError: [Errno 22] Invalid argument"' >> src/twisted/cred/test/test_strcred.py
    echo 'UNIXPasswordDatabaseTests.test_defaultCheckers.skip = "builtins.OSError: [Errno 22] Invalid argument"' >> src/twisted/conch/test/test_checkers.py
    echo 'UNIXPasswordDatabaseTests.test_passInCheckers.skip = "builtins.OSError: [Errno 22] Invalid argument"' >> src/twisted/conch/test/test_checkers.py

    # New failures with 23.8.0
    echo 'MainTests.test_trial.skip = "False is not true : b"' >> src/twisted/test/test_main.py
    echo 'MainTests.test_twisted.skip = "False is not true : b"' >> src/twisted/test/test_main.py

    # not packaged
    substituteInPlace src/twisted/test/test_failure.py \
      --replace "from cython_test_exception_raiser import raiser  # type: ignore[import]" "raiser = None"
  '' + lib.optionalString stdenv.isLinux ''
    echo 'PTYProcessTestsBuilder_EPollReactorTests.test_openFileDescriptors.skip = "invalid syntax"'>> src/twisted/internet/test/test_process.py
    echo 'PTYProcessTestsBuilder_PollReactorTests.test_openFileDescriptors.skip = "invalid syntax"'>> src/twisted/internet/test/test_process.py
    echo 'UNIXTestsBuilder_EPollReactorTests.test_sendFileDescriptorTriggersPauseProducing.skip = "sendFileDescriptor producer was not paused"'>> src/twisted/internet/test/test_unix.py
    echo 'UNIXTestsBuilder_PollReactorTests.test_sendFileDescriptorTriggersPauseProducing.skip = "sendFileDescriptor producer was not paused"'>> src/twisted/internet/test/test_unix.py

    # Patch t.p._inotify to point to libc. Without this,
    # twisted.python.runtime.platform.supportsINotify() == False
    substituteInPlace src/twisted/python/_inotify.py --replace \
      "ctypes.util.find_library(\"c\")" "'${stdenv.cc.libc}/lib/libc.so.6'"
  '' + lib.optionalString (stdenv.isAarch64 && stdenv.isDarwin) ''
    echo 'AbortConnectionTests_AsyncioSelectorReactorTests.test_fullWriteBufferAfterByteExchange.skip = "Timeout after 120 seconds"' >> src/twisted/internet/test/test_tcp.py
    echo 'AbortConnectionTests_AsyncioSelectorReactorTests.test_resumeProducingAbort.skip = "Timeout after 120 seconds"' >> src/twisted/internet/test/test_tcp.py

    echo 'PosixReactorBaseTests.test_removeAllSkipsInternalReaders.skip = "Fails due to unclosed event loop"' >> src/twisted/internet/test/test_posixbase.py
    echo 'PosixReactorBaseTests.test_wakerIsInternalReader.skip = "Fails due to unclosed event loop"' >> src/twisted/internet/test/test_posixbase.py

    echo 'TCPPortTests.test_connectionLostFailed.skip = "Fails due to unclosed event loop"' >> src/twisted/internet/test/test_posixbase.py
  '';

  # Generate Twisted's plug-in cache. Twisted users must do it as well. See
  # http://twistedmatrix.com/documents/current/core/howto/plugin.html#auto3
  # and http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=477103 for details.
  postFixup = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    $out/bin/twistd --help > /dev/null
  '';

  nativeCheckInputs = [
    git
    glibcLocales
    hypothesis
    pyhamcrest
  ]
  ++ passthru.optional-dependencies.conch
  # not supported on aarch64-darwin: https://github.com/pyca/pyopenssl/issues/873
  ++ lib.optionals (!(stdenv.isDarwin && stdenv.isAarch64)) passthru.optional-dependencies.tls;

  checkPhase = ''
    export SOURCE_DATE_EPOCH=315532800
    export PATH=$out/bin:$PATH
    # race conditions when running in parallel
    ${python.interpreter} -m twisted.trial twisted
  '';

  passthru = {
    optional-dependencies = rec {
      conch = [
        appdirs
        bcrypt
        cryptography
      ];
      conch_nacl = conch ++ [
        pynacl
      ];
      http2 = [
        h2
        priority
      ];
      serial = [
        pyserial
      ];
      tls = [
        idna
        pyopenssl
        service-identity
      ];
    };

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
        thrift;
      inherit (nixosTests) buildbot matrix-synapse;
    };
  };

  meta = with lib; {
    description = "Asynchronous networking framework written in Python";
    homepage = "https://github.com/twisted/twisted";
    changelog = "https://github.com/twisted/twisted/blob/twisted-${version}/NEWS.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
