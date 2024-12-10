{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libarchive,
}:

stdenv.mkDerivation rec {
  pname = "genext2fs";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "bestouff";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-9LAU5XuCwwEhU985MzZ2X+YYibvyECULQSn9X2jdj5I=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    libarchive
  ];

  configureFlags = [
    "--enable-libarchive"
  ];

  doCheck = true;
  checkPhase = ''
    ./test.sh
  '';

  meta = with lib; {
    homepage = "https://github.com/bestouff/genext2fs";
    description = "A tool to generate ext2 filesystem images without requiring root privileges";
    license = licenses.gpl2Only;
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
    mainProgram = "genext2fs";
  };
}
