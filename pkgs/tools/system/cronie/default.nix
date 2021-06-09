{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "cronie";
  version = "1.5.5";

  src = fetchurl {
    url = "https://github.com/cronie-crond/cronie/releases/download/cronie-${version}/cronie-${version}.tar.gz";
    sha256 = "1b0ffbjxmpf0yyfrympfc2qidzsmk55p8m0q50il6m750nawfd5y";
  };

  meta = with stdenv.lib; {
    description = "Daemon that runs specified programs at scheduled times and related tools";
    homepage = "https://github.com/cronie-crond/cronie";
    license = with licenses; [ mit /* and */ bsd3 /* and */ isc /* and */ gpl2Plus ];
    platforms = platforms.unix;
    maintainers = [ maintainers.marsam ];
  };
}
