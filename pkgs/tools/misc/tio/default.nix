{ stdenv, fetchzip, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "tio";
  version = "1.32";

  src = fetchzip {
    url = "https://github.com/tio/tio/archive/v${version}.tar.gz";
    sha256 = "0lwqdm73kshi9qs8pks1b4by6yb9jf3bbyw3bv52xmggnr5s1hcv";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with stdenv.lib; {
    description = "Serial console TTY";
    homepage = https://tio.github.io/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ yegortimoshenko ];
    platforms = platforms.unix;
  };
}
