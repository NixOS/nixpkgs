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

  meta = with lib; {
    description = "FUSE for access Playstation 2 IOP IOPRP images and BIOS dumps";
    homepage = "https://github.com/mlafeldt/romdirfs";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ];
    mainProgram = "romdirfs";
  };
}
