{
  lib,
  stdenv,
  fetchFromGitHub,
  curl,
  jdk,
  libedit,
  srt,
}:

stdenv.mkDerivation rec {
  pname = "tsduck";
  version = "3.31-2761";

  src = fetchFromGitHub {
    owner = "tsduck";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-268TKCh3naebbw+sOQ6d4N/zl7UEVtc3l3flFAYHDU4=";
  };

  buildInputs = [
    curl
    libedit
    srt
    jdk
  ];

  # remove tests which call out to https://tsduck.io/download/test/...
  postPatch = ''
    sed -i"" \
      -e '/TSUNIT_TEST(testMasterPlaylist);/ d' \
      -e '/TSUNIT_TEST(testMasterPlaylistWithAlternate);/ d' \
      -e '/TSUNIT_TEST(testMediaPlaylist);/ d' \
      src/utest/utestHLS.cpp

    sed -i"" \
      -e '/TSUNIT_TEST(testBetterSystemRandomGenerator);/ d' \
      src/utest/utestSystemRandomGenerator.cpp

    sed -i"" \
      -e '/TSUNIT_ASSERT(request.downloadBinaryContent/ d' \
      -e '/TSUNIT_ASSERT(!request.downloadBinaryContent/ d' \
      -e '/TSUNIT_TEST(testGitHub);/ d' \
      -e '/TSUNIT_TEST(testGoogle);/ d' \
      -e '/TSUNIT_TEST(testNoRedirection);/ d' \
      -e '/TSUNIT_TEST(testReadMeFile);/ d' \
      src/utest/utestWebRequest.cpp

    sed -i"" \
      -e '/TSUNIT_TEST(testHomeDirectory);/ d' \
      src/utest/utestSysUtils.cpp

    sed -i"" \
      -e '/TSUNIT_TEST(testIPv4Address);/ d' \
      -e '/TSUNIT_TEST(testIPv4AddressConstructors);/ d' \
      -e '/TSUNIT_TEST(testIPv4SocketAddressConstructors);/ d' \
      -e '/TSUNIT_TEST(testTCPSocket);/ d' \
      -e '/TSUNIT_TEST(testUDPSocket);/ d' \
      src/utest/utestNetworking.cpp
  '';

  enableParallelBuilding = true;
  makeFlags = [
    "NODEKTEC=1"
    "NOHIDES=1"
    "NOPCSC=1"
    "NORIST=1"
    "NOVATEK=1"
  ] ++ installFlags;

  checkTarget = "test";
  doCheck = true;

  installFlags = [
    "SYSROOT=${placeholder "out"}"
    "SYSPREFIX=/"
    "USRLIBDIR=/lib"
  ];
  installTargets = [
    "install-tools"
    "install-devel"
  ];

  meta = with lib; {
    description = "The MPEG Transport Stream Toolkit";
    homepage = "https://github.com/tsduck/tsduck";
    license = licenses.bsd2;
    maintainers = with maintainers; [ siriobalmelli ];
    platforms = platforms.all;
    # never built on aarch64-darwin, x86_64-darwin since first introduction in nixpkgs
    broken = stdenv.isDarwin;
  };
}
