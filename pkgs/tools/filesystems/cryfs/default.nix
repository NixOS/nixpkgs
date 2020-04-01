{ stdenv, fetchFromGitHub, fetchpatch
, cmake, pkgconfig, python, gtest
, boost, cryptopp, curl, fuse, openssl
}:

stdenv.mkDerivation rec {
  pname = "cryfs";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner  = "cryfs";
    repo   = "cryfs";
    rev    = version;
    sha256 = "1m6rcc82hbaiwcwcvf5xmxma8n0jal9zhcykv9xgwiax4ny0l8kz";
  };

  patches = [
    (fetchpatch {
      name = "cryfs-0.10.2-install-targets.patch";
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/sys-fs/cryfs/files/cryfs-0.10.2-install-targets.patch?id=192ac7421ddd4093125f4997898fb62e8a140a44";
      sha256 = "1jz6gpi1i7dnfm88a6n3mccwfmsmvg0d0bmp3fmqqrkbcg7in00l";
    })
    (fetchpatch {
      name = "cryfs-0.10.2-unbundle-libs.patch";
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/sys-fs/cryfs/files/cryfs-0.10.2-unbundle-libs.patch?id=192ac7421ddd4093125f4997898fb62e8a140a44";
      sha256 = "0hzss5rawcjrh8iqzc40w5yjhxdqya4gbg6dzap70180s50mahzs";
    })
  ];

  postPatch = ''
    patchShebangs src

    # remove tests that require network access:
    substituteInPlace test/cpp-utils/CMakeLists.txt \
      --replace "network/CurlHttpClientTest.cpp" "" \
      --replace "network/FakeHttpClientTest.cpp" ""

    # remove CLI test trying to access /dev/fuse
    substituteInPlace test/cryfs-cli/CMakeLists.txt \
      --replace "CliTest_IntegrityCheck.cpp" ""

    # downsize large file test as 4.5G is too big for Hydra:
    substituteInPlace test/cpp-utils/data/DataTest.cpp \
      --replace "(4.5L*1024*1024*1024)" "(0.5L*1024*1024*1024)"
  '';

  nativeBuildInputs = [ cmake gtest pkgconfig python ];

  buildInputs = [ boost cryptopp curl fuse openssl ];

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DCRYFS_UPDATE_CHECKS:BOOL=FALSE"
    "-DBoost_USE_STATIC_LIBS:BOOL=FALSE" # this option is case sensitive
    "-DUSE_SYSTEM_LIBS:BOOL=TRUE"
    "-DBUILD_TESTING:BOOL=TRUE"
  ];

  doCheck = (!stdenv.isDarwin); # Cryfs tests are broken on darwin

  checkPhase = ''
    # Skip CMakeFiles directory and tests depending on fuse (does not work well with sandboxing)
    SKIP_IMPURE_TESTS="CMakeFiles|fspp|my-gtest-main"

    for t in $(ls -d test/*/ | egrep -v "$SKIP_IMPURE_TESTS"); do
      "./$t$(basename $t)-test"
    done
  '';

  meta = with stdenv.lib; {
    description = "Cryptographic filesystem for the cloud";
    homepage    = "https://www.cryfs.org";
    license     = licenses.lgpl3;
    maintainers = with maintainers; [ peterhoeg c0bw3b ];
    platforms   = with platforms; linux;
  };
}
