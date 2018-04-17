{ stdenv, fetchFromGitHub
, cmake
, fuse }:

stdenv.mkDerivation rec {
  name = "securefs-${version}";
  version = "0.8.1";

  src = fetchFromGitHub {
    sha256 = "065n3mskv0b2dlk9w4b3pa70h5ymrnanydbanwyx74mf7n8c80r2";
    rev = version;
    repo = "securefs";
    owner = "netheril96";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ fuse ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
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
    platforms = platforms.linux;
  };
}
