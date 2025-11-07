{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  perl,
  gettext,
  fuse,
  openssl,
  tinyxml-2,
  gtest,
}:

stdenv.mkDerivation rec {
  pname = "encfs";
  version = "1.9.5";

  src = fetchFromGitHub {
    sha256 = "099rjb02knr6yz7przlnyj62ic0ag5ncs7vvcc36ikyqrmpqsdch";
    rev = "v${version}";
    repo = "encfs";
    owner = "vgough";
  };

  patches = lib.optionals stdenv.cc.isClang [
    # Fixes a build failure when building with newer versions of clang.
    # https://github.com/vgough/encfs/pull/650
    (fetchpatch {
      url = "https://github.com/vgough/encfs/commit/406b63bfe234864710d1d23329bf41d48001fbfa.patch";
      hash = "sha256-VunC5ICRJBgCXqkr7ad7DPzweRJr1bdOpo1LKNCs4zY=";
    })
  ];

  buildInputs = [
    fuse
    openssl
    tinyxml-2
    gtest
  ];
  nativeBuildInputs = [
    cmake
    pkg-config
    perl
    gettext
  ];
  strictDeps = true;

  cmakeFlags = [
    "-DUSE_INTERNAL_TINYXML=OFF"
    "-DBUILD_SHARED_LIBS=ON"
    "-DINSTALL_LIBENCFS=ON"

    # Fix the build with CMake 4.
    #
    # Upstream is deprecated, so it won’t be fixed there. We should
    # probably phase this package out.
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.10"
  ];

  meta = with lib; {
    description = "Encrypted filesystem in user-space via FUSE";
    homepage = "https://vgough.github.io/encfs";
    license = with licenses; [
      gpl3Plus
      lgpl3Plus
    ];
    platforms = platforms.unix;
    # The last successful Darwin Hydra build was in 2024
    broken = stdenv.hostPlatform.isDarwin;
  };
}
