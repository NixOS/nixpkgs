{ lib, stdenv, fetchurl, autoreconfHook }:
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
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ edef ];
    platforms = lib.platforms.all;
  };
}
