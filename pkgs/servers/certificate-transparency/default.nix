{ stdenv, fetchFromGitHub, autoreconfHook, clang, pkgconfig
, glog, gmock, gtest, google-gflags, gperftools, json_c, leveldb
, libevent, libevhtp, openssl, protobuf, sqlite
}:

stdenv.mkDerivation rec {
  name = "certificate-transparency-${version}";

  version = "2016-01-14";
  rev = "250672b5aef3666edbdfc9a75b95a09e7a57ed08";

  src = fetchFromGitHub {
    owner = "google";
    repo  = "certificate-transparency";
    rev   = rev;
    sha256 = "1gn0bqzkf09jvc2aq3da8fwhl65y7q57msqsh6iczvd6fdmrpfdj";
  };

  # need to disable regex support in evhtp or building will fail
  libevhtp_without_regex = stdenv.lib.overrideDerivation libevhtp
    (oldAttrs: {
      cmakeFlags = "-DEVHTP_DISABLE_REGEX:STRING=ON";
    });

  buildInputs = [
    autoreconfHook clang pkgconfig
    glog gmock google-gflags gperftools gtest json_c leveldb
    libevent libevhtp_without_regex openssl protobuf sqlite
  ];

  patches = [
    ./protobuf-include-from-env.patch
  ];

  configureFlags = [
    "CC=clang"
    "CXX=clang++"
    "GMOCK_DIR=${gmock}"
    "GTEST_DIR=${gtest}"
  ];

  # the default Makefile constructs BUILD_VERSION from `git describe`
  # which isn't available in the nix build environment
  makeFlags = "BUILD_VERSION=${version}-${rev}";

  protocFlags = "-I ${protobuf}/include";

  meta = with stdenv.lib; {
    homepage = https://www.certificate-transparency.org/;
    description = "Auditing for TLS certificates.";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ philandstuff ];
  };
}
