{ lib
, stdenv
, fetchFromGitHub
, cmake
, fuse
}:

stdenv.mkDerivation rec {
  pname = "securefs";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "netheril96";
    repo = "securefs";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-7xjGuN7jcLgfGkaBoSj+WsBpM806PPGzeBs7DnI+fwc=";
  };

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
  };
}
