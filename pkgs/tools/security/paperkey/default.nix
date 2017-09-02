{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "paperkey-${version}";
  version = "1.4";

  src = fetchurl {
    url = "http://www.jabberwocky.com/software/paperkey/${name}.tar.gz";
    sha256 = "0vrkryxqbsjcmqalsnxvc3pahg6vvyrn139aj8md29sihgnb0az1";
  };

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Store OpenPGP or GnuPG on paper";
    longDescription = ''
      A reasonable way to achieve a long term backup of OpenPGP (GnuPG, PGP, etc)
      keys is to print them out on paper. Paper and ink have amazingly long
      retention qualities - far longer than the magnetic or optical means that
      are generally used to back up computer data.
    '';
    homepage = http://www.jabberwocky.com/software/paperkey/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ skeidel ];
  };
}
