{ stdenv, fetchFromGitHub
, cmake, pkgconfig, coreutils
, boost, cryptopp, curl, fuse, openssl, python, spdlog
}:

stdenv.mkDerivation rec {
  name = "cryfs-${version}";
  version = "0.9.7";

  src = fetchFromGitHub {
    owner  = "cryfs";
    repo   = "cryfs";
    rev    = "${version}";
    sha256 = "1wsv4cyjkyg3cyr6vipw1mj41bln2m69123l3miav8r4mvmkfq8w";
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

  # coreutils is needed for the vendored scrypt
  nativeBuildInputs = [ cmake coreutils pkgconfig ];

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DCRYFS_UPDATE_CHECKS=OFF"
    "-DBoost_USE_STATIC_LIBS=OFF" # this option is case sensitive
    "-DBUILD_TESTING=ON"
  ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Cryptographic filesystem for the cloud";
    homepage    = https://www.cryfs.org;
    license     = licenses.lgpl3;
    maintainers = with maintainers; [ peterhoeg ];
    platforms   = with platforms; linux;
  };
}
