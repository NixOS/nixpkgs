{ fetchurl, stdenv }:

stdenv.mkDerivation rec {

  version = "1.3";
  name = "paperkey-${version}";
  
  src = fetchurl {
    url = "http://www.jabberwocky.com/software/paperkey/${name}.tar.gz";
    sha256 = "5b57d7522336fb65c4c398eec27bf44ec0aaa35926157b79a76423231792cbfb";
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
    homepage = "http://www.jabberwocky.com/software/paperkey/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.skeidel ];
  };
}
