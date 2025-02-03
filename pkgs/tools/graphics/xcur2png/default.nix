{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  libpng,
  xorg,
}:

stdenv.mkDerivation rec {
  pname = "xcur2png";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "eworm-de";
    repo = pname;
    rev = version;
    sha256 = "0858wn2p14bxpv9lvaz2bz1rk6zk0g8zgxf8iy595m8fqv4q2fya";
  };

  patches = [
    # https://github.com/eworm-de/xcur2png/pull/3
    ./malloc.diff

    # fix byte overflows due to off-by-one error
    (fetchpatch {
      url = "https://github.com/eworm-de/xcur2png/commit/aa035462d950fab35d322cb87fd2f0d702251e82.patch";
      hash = "sha256-hlmJ/bcDSl1ADs0jp+JrAgAaMzielUSRVPad+plnSZg=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libpng
    xorg.libX11
    xorg.libXcursor
    xorg.xorgproto
  ];

  meta = with lib; {
    homepage = "https://github.com/eworm-de/xcur2png/releases";
    description = "Convert X cursors to PNG images";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ romildo ];
    mainProgram = "xcur2png";
  };
}
