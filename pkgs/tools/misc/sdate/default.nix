{ stdenv, fetchurl, autoreconfHook }:
stdenv.mkDerivation rec {
  pname = "sdate";
  version = "0.7";
  src = fetchurl {
    url = "https://github.com/ChristophBerg/sdate/archive/${version}.tar.gz";
    sha256 = "1lfnsb8prac8rspnxcawd138jyhyivwf35rrmfvwq6dhsx23c6vy";
  };

  buildInputs = [ autoreconfHook ];

  meta = {
    homepage = "https://www.df7cb.de/projects/sdate";
    description = "Eternal september version of the date program";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ edef ];
    platforms = stdenv.lib.platforms.all;
  };
}
