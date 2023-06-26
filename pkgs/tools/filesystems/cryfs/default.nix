{ lib, stdenv, fetchFromGitHub
, cmake, pkg-config, python3
, boost, curl, fuse, openssl, range-v3, spdlog
# cryptopp and gtest on standby - using the vendored ones for now
# see https://github.com/cryfs/cryfs/issues/369
, llvmPackages
}:

stdenv.mkDerivation rec {
  pname = "cryfs";
  version = "0.11.3";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    hash = "sha256-7luTCDjrquG8aBZ841VPwV9/ea8faHGLQtmRahqGTss=";
  };

  postPatch = ''
    patchShebangs src

    # remove tests that require network access
    substituteInPlace test/cpp-utils/CMakeLists.txt \
      --replace "network/CurlHttpClientTest.cpp" "" \
      --replace "network/FakeHttpClientTest.cpp" ""

    # remove CLI test trying to access /dev/fuse
    substituteInPlace test/cryfs-cli/CMakeLists.txt \
      --replace "CliTest_IntegrityCheck.cpp" "" \
      --replace "CliTest_Setup.cpp" "" \
      --replace "CliTest_WrongEnvironment.cpp" "" \
      --replace "CryfsUnmountTest.cpp" ""

    # downsize large file test as 4.5G is too big for Hydra
    substituteInPlace test/cpp-utils/data/DataTest.cpp \
      --replace "(4.5L*1024*1024*1024)" "(0.5L*1024*1024*1024)"
  '';

  nativeBuildInputs = [ cmake pkg-config python3 ];

  strictDeps = true;

  buildInputs = [ boost curl fuse openssl range-v3 spdlog ]
    ++ lib.optional stdenv.cc.isClang llvmPackages.openmp;

  #nativeCheckInputs = [ gtest ];

  cmakeFlags = [
    "-DDEPENDENCY_CONFIG='../cmake-utils/DependenciesFromLocalSystem.cmake'"
    "-DCRYFS_UPDATE_CHECKS:BOOL=FALSE"
    "-DBoost_USE_STATIC_LIBS:BOOL=FALSE" # this option is case sensitive
    "-DBUILD_TESTING:BOOL=${if doCheck then "TRUE" else "FALSE"}"
  ]; # ++ lib.optional doCheck "-DCMAKE_PREFIX_PATH=${gtest.dev}/lib/cmake";

  # macFUSE needs to be installed for the test to succeed on Darwin
  doCheck = !stdenv.isDarwin;

  checkPhase = ''
    runHook preCheck
    export HOME=$(mktemp -d)

    # Skip CMakeFiles directory and tests depending on fuse (does not work well with sandboxing)
    SKIP_IMPURE_TESTS="CMakeFiles|fspp|my-gtest-main"

    for t in $(ls -d test/*/ | grep -E -v "$SKIP_IMPURE_TESTS") ; do
      "./$t$(basename $t)-test"
    done

    runHook postCheck
  '';

  meta = with lib; {
    description = "Cryptographic filesystem for the cloud";
    homepage    = "https://www.cryfs.org/";
    changelog   = "https://github.com/cryfs/cryfs/raw/${version}/ChangeLog.txt";
    license     = licenses.lgpl3Only;
    maintainers = with maintainers; [ peterhoeg c0bw3b ];
    platforms   = platforms.unix;
  };
}
