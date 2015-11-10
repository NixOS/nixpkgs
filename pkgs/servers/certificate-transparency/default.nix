{ stdenv, pkgs, ...}:

stdenv.mkDerivation rec {
  name = "certificate-transparency-${version}";

  version = "2015-11-27";
  rev = "dc5a51e55af989ff5871a6647166d00d0de478ab";

  meta = with stdenv.lib; {
    homepage = https://www.certificate-transparency.org/;
    description = "Auditing for TLS certificates.";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ philandstuff ];
  };

  src = pkgs.fetchFromGitHub {
    owner = "google";
    repo  = "certificate-transparency";
    rev   = rev;
    sha256 = "14sgc2kcjjsnrykwcjin21h1f3v4kg83w6jqiq9qdm1ha165yhvx";
  };

  # need to disable regex support in evhtp or building will fail
  libevhtp_without_regex = stdenv.lib.overrideDerivation pkgs.libevhtp
    (oldAttrs: {
      cmakeFlags="-DEVHTP_DISABLE_REGEX:STRING=ON -DCMAKE_C_FLAGS:STRING=-fPIC";
    });

  buildInputs = with pkgs; [
    autoconf automake clang_34 pkgconfig
    glog gmock google-gflags gperftools gtest json_c leveldb
    libevent libevhtp_without_regex openssl protobuf sqlite
  ];

  patches = [
    ./protobuf-include-from-env.patch
  ];

  doCheck = false;

  preConfigure = ''
    ./autogen.sh
    configureFlagsArray=(
      CC=clang
      CXX=clang++
      GMOCK_DIR=${pkgs.gmock}
      GTEST_DIR=${pkgs.gtest}
    )
  '';

  # the default Makefile constructs BUILD_VERSION from `git describe`
  # which isn't available in the nix build environment
  makeFlags = "BUILD_VERSION=${version}-${rev}";

  protocFlags = "-I ${pkgs.protobuf}/include";
}
