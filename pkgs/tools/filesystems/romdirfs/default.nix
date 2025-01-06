{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  fuse,
}:

stdenv.mkDerivation rec {
  pname = "romdirfs";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "mlafeldt";
    repo = "romdirfs";
    rev = "v${version}";
    sha256 = "1jbsmpklrycz5q86qmzvbz4iz2g5fvd7p9nca160aw2izwpws0g7";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [ fuse ];

  meta = {
    description = "FUSE for access Playstation 2 IOP IOPRP images and BIOS dumps";
    homepage = "https://github.com/mlafeldt/romdirfs";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    maintainers = [ ];
    mainProgram = "romdirfs";
  };
}
