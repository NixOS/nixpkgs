{ stdenv, fetchzip, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "tio-${version}";
  version = "1.31";

  src = fetchzip {
    url = "https://github.com/tio/tio/archive/v${version}.tar.gz";
    sha256 = "1164ida1vxvm0z76nmkk2d5y9i3wj8rni9sl1mid6c09gi4k2slk";
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
