{ stdenv, fetchurl, autoreconfHook }:
stdenv.mkDerivation rec {
  pname = "sdate";
  version = "0.6";
  src = fetchurl {
    url = "https://github.com/ChristophBerg/sdate/archive/${version}.tar.gz";
    sha256 = "11irlbbhlzkg6y621smk351jl8ay3yjhl2j9hila0xa72hs4n7gz";
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
