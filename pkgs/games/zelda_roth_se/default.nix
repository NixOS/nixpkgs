{ stdenv, fetchgit, cmake, zip }:

stdenv.mkDerivation rec {
  name = "zelda_roth_se-${version}";
  version = "1.0.8";
  
  src = fetchgit {
    url = "https://github.com/christopho/zelda_roth_se.git";
    rev = "90060af19bb84e391571f31a1f394aa04cc812c3";
    sha256 = "0217mrw995ccim80bl6yaypbsanhvdns4z1qkxfpfxj7ipf7bjk7";
  };
  
  buildInputs = [ cmake zip ];

  meta = with stdenv.lib; {
    description = "A solarus quest";
    longDescription = ''
      The Legend of Zelda: Return of the Hylian Solarus Edition
      is a Solarus remake of Vincent Jouillat's fan game of similar
      name. It is written in lua.
    '';
    homepage = http://www.solarus-games.org;
    license = licenses.gpl3;
    maintainers = [ maintainers.Nate-Devv ];
    platforms = platforms.all;
  };
  
}
