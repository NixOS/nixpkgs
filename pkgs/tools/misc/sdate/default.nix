{ stdenv, fetchurl, autoreconfHook }:
stdenv.mkDerivation rec {
  name = "sdate-${version}";
  version = "0.5";
  src = fetchurl {
    url = "https://github.com/ChristophBerg/sdate/archive/${version}.tar.gz";
    sha256 = "0gbjl1jfxjwiiwf9rz38yp6rb1mgzhawcyg0g9byl6m4kgivf0cx";
  };

  buildInputs = [ autoreconfHook ];

  meta = {
    homepage = https://www.df7cb.de/projects/sdate;
    description = "Eternal september version of the date program";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ edef ];
    platforms = stdenv.lib.platforms.all;
  };
}
