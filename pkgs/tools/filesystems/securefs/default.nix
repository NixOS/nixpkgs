{ lib, stdenv, fetchFromGitHub
, cmake
, fuse }:

stdenv.mkDerivation rec {
  pname = "securefs";
  version = "0.11.1";

  src = fetchFromGitHub {
    sha256 = "1sxfgqgy63ml7vg7zj3glvra4wj2qmfv9jzmpm1jqy8hq7qlqlsx";
    rev = version;
    repo = "securefs";
    owner = "netheril96";
    fetchSubmodules = true;
  };

  patches = [
    # Make it build with macFUSE
    # Backported from https://github.com/netheril96/securefs/pull/114
    ./add-macfuse-support.patch
  ];

  postPatch = ''
    sed -i -e '/TEST_SOURCES/d' CMakeLists.txt
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ fuse ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Transparent encryption filesystem";
    longDescription = ''
      Securefs is a filesystem in userspace (FUSE) that transparently encrypts
      and authenticates data stored. It is particularly designed to secure
      data stored in the cloud.
      Securefs mounts a regular directory onto a mount point. The mount point
      appears as a regular filesystem, where one can read/write/create files,
      directories and symbolic links. The underlying directory will be
      automatically updated to contain the encrypted and authenticated
      contents.
    '';
    license = with licenses; [ bsd2 mit ];
    platforms = platforms.unix;
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken = stdenv.isDarwin && stdenv.isAarch64;
  };
}
