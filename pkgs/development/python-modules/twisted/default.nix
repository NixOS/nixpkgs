{ lib
, stdenv
, buildPythonPackage
, pythonAtLeast
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
      name = "11787.diff";
      url = "https://github.com/twisted/twisted/commit/da3bf3dc29f067e7019b2a1c205834ab64b2139a.diff";
      hash = "sha256-bQgUmbvDa61Vg8p/o/ivfkOAHyj1lTgHkrRVEGLM9aU=";
    })
    (fetchpatch {
      # Conditionally skip tests that require METHOD_CRYPT
      # https://github.com/twisted/twisted/pull/11827
      url = "https://github.com/mweinelt/twisted/commit/e69e652de671aac0abf5c7e6c662fc5172758c5a.patch";
      hash = "sha256-LmvKUTViZoY/TPBmSlx4S9FbJNZfB5cxzn/YcciDmoI=";
    })
    # remove half broken pyasn1 integration that blow up with pyasn 0.5.0
    # https://github.com/twisted/twisted/pull/11843
    (fetchpatch {
      url = "https://github.com/twisted/twisted/commit/bdee0eb835a76b2982beaf10c85269ff25ea09fa.patch";
      excludes = [ "pyproject.toml" "tox.ini" ];
      hash = "sha256-oGAHmZMpMWfK+2zEDjHD115sW7exCYqfORVOLw+Wa6M=";
    })
  ] ++ lib.optionals (pythonAtLeast "3.11") [
    (fetchpatch {
      url = "https://github.com/twisted/twisted/pull/11734.diff";
      excludes = [ ".github/workflows/*" ];
      hash = "sha256-Td08pDxHwl7fPLCA6rUySuXpy8YmZfvXPHGsBpdcmSo=";
    })
    (fetchpatch {
      url = "https://github.com/twisted/twisted/commit/00bf5be704bee022ba4d9b24eb6c2c768b4a1921.patch";
      hash = "sha256-fnBzczm3OlhbjRcePIQ7dSX6uldlCZ9DJTS+UFO2nAQ=";
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
    substituteInPlace pyproject.toml \
      --replace '"pyasn1 >= 0.4",' ""

    echo 'ListingTests.test_localeIndependent.skip = "Timezone issue"'>> src/twisted/conch/test/test_cftp.py
    echo 'ListingTests.test_newFile.skip = "Timezone issue"'>> src/twisted/conch/test/test_cftp.py
    echo 'ListingTests.test_newSingleDigitDayOfMonth.skip = "Timezone issue"'>> src/twisted/conch/test/test_cftp.py
    echo 'ListingTests.test_oldFile.skip = "Timezone issue"'>> src/twisted/conch/test/test_cftp.py
    echo 'ListingTests.test_oldSingleDigitDayOfMonth.skip = "Timezone issue"'>> src/twisted/conch/test/test_cftp.py

    echo 'WrapClientTLSParserTests.test_tls.skip = "pyopenssl update"' >> src/twisted/internet/test/test_endpoints.py
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
  '' + lib.optionalString stdenv.isDarwin ''
    echo 'ProcessTestsBuilder_AsyncioSelectorReactorTests.test_openFileDescriptors.skip = "invalid syntax"'>> src/twisted/internet/test/test_process.py
    echo 'ProcessTestsBuilder_SelectReactorTests.test_openFileDescriptors.skip = "invalid syntax"'>> src/twisted/internet/test/test_process.py
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
    # race conditions when running in paralell
    ${python.interpreter} -m twisted.trial -j1 twisted
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
    maintainers = with maintainers; [ ];
  };
}
