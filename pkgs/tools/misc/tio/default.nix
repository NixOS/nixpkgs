{ stdenv, fetchzip, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "tio-${version}";
  version = "1.30";

  src = fetchzip {
    url = "https://github.com/tio/tio/archive/v${version}.tar.gz";
    sha256 = "1cyjy1jg2s32h1jkb99qb79sxkxh92niiyig0vysr14m4xnw01mr";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with stdenv.lib; {
    description = "Serial console TTY";
    homepage = https://tio.github.io/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ yegortimoshenko ];
    platforms = platforms.linux;
  };
}
