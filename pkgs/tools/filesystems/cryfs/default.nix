{ stdenv, fetchFromGitHub
, cmake, pkgconfig, coreutils
, boost, cryptopp, curl, fuse, openssl, python, spdlog
}:

stdenv.mkDerivation rec {
  name = "cryfs-${version}";
  version = "0.9.10";

  src = fetchFromGitHub {
    owner  = "cryfs";
    repo   = "cryfs";
    rev    = "${version}";
    sha256 = "04yqpad8x0hiiwpykcn3swi0py6sg9xid6g15ny2qs4j3llin5ry";
  };

  prePatch = ''
    patchShebangs src

    substituteInPlace vendor/scrypt/CMakeLists.txt \
      --replace /usr/bin/ ""

    # scrypt in nixpkgs only produces a binary so we lift the patching from that so allow
    # building the vendored version. This is very much NOT DRY.
    # The proper solution is to have scrypt generate a dev output with the required files and just symlink
    # into vendor/scrypt
    for f in Makefile.in autocrap/Makefile.am libcperciva/cpusupport/Build/cpusupport.sh ; do
      substituteInPlace vendor/scrypt/scrypt-*/scrypt/$f --replace "command -p " ""
    done

    # cryfs is vendoring an old version of spdlog
    rm -rf vendor/spdlog/spdlog
    ln -s ${spdlog} vendor/spdlog/spdlog
  '';

  buildInputs = [ boost cryptopp curl fuse openssl python spdlog ];

  patches = [
    ./test-no-network.patch  # Disable tests using external networking
    ./skip-failing-test-large-malloc.patch
  ];

  # coreutils is needed for the vendored scrypt
  nativeBuildInputs = [ cmake coreutils pkgconfig ];

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DCRYFS_UPDATE_CHECKS=OFF"
    "-DBoost_USE_STATIC_LIBS=OFF" # this option is case sensitive
  ];

  doCheck = true;

  # Cryfs tests are broken on darwin
  checkPhase = stdenv.lib.optionalString (!stdenv.isDarwin) ''
    # Skip CMakeFiles directory and tests depending on fuse (does not work well with sandboxing)
    SKIP_IMPURE_TESTS="CMakeFiles|fspp|cryfs-cli"

    for test in `ls -d test/*/ | egrep -v "$SKIP_IMPURE_TESTS"`; do
      "./$test`basename $test`-test"
    done
  '';

  installPhase = ''
    # Building with BUILD_TESTING=ON is missing the install target
    mkdir -p $out/bin
    install -m 755 ./src/cryfs-cli/cryfs $out/bin/cryfs
  '';

  meta = with stdenv.lib; {
    description = "Cryptographic filesystem for the cloud";
    homepage    = https://www.cryfs.org;
    license     = licenses.lgpl3;
    maintainers = with maintainers; [ peterhoeg ];
    platforms   = with platforms; linux;
  };
}
