{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchPypi
, fetchpatch
, python
, appdirs
, attrs
, automat
, bcrypt
, constantly
, cryptography
, git
, glibcLocales
, h2
, hyperlink
, hypothesis
, idna
, incremental
, priority
, pyasn1
, pyhamcrest
, pynacl
, pyopenssl
, pyserial
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
  version = "22.10.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "Twisted";
    inherit version;
    extension = "tar.gz";
    hash = "sha256-Mqy9QKlPX0bntCwQm/riswIlCUVWF4Oot6BZBI8tTTE=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/twisted/twisted/pull/11787.diff";
      hash = "sha256-bQgUmbvDa61Vg8p/o/ivfkOAHyj1lTgHkrRVEGLM9aU=";
    })
  ];

  __darwinAllowLocalNetworking = true;

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
    echo 'ListingTests.test_localeIndependent.skip = "Timezone issue"'>> src/twisted/conch/test/test_cftp.py
    echo 'ListingTests.test_newFile.skip = "Timezone issue"'>> src/twisted/conch/test/test_cftp.py
    echo 'ListingTests.test_newSingleDigitDayOfMonth.skip = "Timezone issue"'>> src/twisted/conch/test/test_cftp.py
    echo 'ListingTests.test_oldFile.skip = "Timezone issue"'>> src/twisted/conch/test/test_cftp.py
    echo 'ListingTests.test_oldSingleDigitDayOfMonth.skip = "Timezone issue"'>> src/twisted/conch/test/test_cftp.py

    echo 'UNIXTestsBuilder_AsyncioSelectorReactorTests.test_sendFileDescriptorTriggersPauseProducing.skip = "sendFileDescriptor producer was not paused"'>> src/twisted/internet/test/test_unix.py
    echo 'UNIXTestsBuilder_SelectReactorTests.test_sendFileDescriptorTriggersPauseProducing.skip = "sendFileDescriptor producer was not paused"'>> src/twisted/internet/test/test_unix.py

    echo 'FileObserverTests.test_getTimezoneOffsetEastOfUTC.skip = "mktime argument out of range"'>> src/twisted/test/test_log.py
    echo 'FileObserverTests.test_getTimezoneOffsetWestOfUTC.skip = "mktime argument out of range"'>> src/twisted/test/test_log.py
    echo 'FileObserverTests.test_getTimezoneOffsetWithoutDaylightSavingTime.skip = "tuple differs, values not"'>> src/twisted/test/test_log.py

    echo 'MulticastTests.test_joinLeave.skip = "No such device"'>> src/twisted/test/test_udp.py
    echo 'MulticastTests.test_loopback.skip = "No such device"'>> src/twisted/test/test_udp.py
    echo 'MulticastTests.test_multicast.skip = "Reactor was unclean"'>> src/twisted/test/test_udp.py
    echo 'MulticastTests.test_multiListen.skip = "No such device"'>> src/twisted/test/test_udp.py

    # fails since migrating to libxcrypt
    echo 'HelperTests.test_refuteCryptedPassword.skip = "OSError: Invalid argument"' >> src/twisted/conch/test/test_checkers.py

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
  postFixup = ''
    $out/bin/twistd --help > /dev/null
  '';

  checkInputs = [
    git
    glibcLocales
    # "hypothesis" indirectly depends on twisted to build its documentation.
    (hypothesis.override { enableDocumentation = false; })
    pyhamcrest
  ]
  ++ passthru.optional-dependencies.conch
  # not supported on aarch64-darwin: https://github.com/pyca/pyopenssl/issues/873
  ++ lib.optionals (!(stdenv.isDarwin && stdenv.isAarch64)) passthru.optional-dependencies.tls;

  checkPhase = ''
    export SOURCE_DATE_EPOCH=315532800
    export PATH=$out/bin:$PATH
    # race conditions when running in paralell
    ${python.interpreter} -m twisted.trial twisted
  '';

  passthru = {
    optional-dependencies = rec {
      conch = [ appdirs bcrypt cryptography pyasn1 ];
      conch_nacl = conch ++ [ pynacl ];
      http2 = [ h2 priority ];
      serial = [ pyserial ];
      tls = [ idna pyopenssl service-identity ];
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
    homepage = "https://github.com/twisted/twisted";
    description = "Asynchronous networking framework written in Python";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
