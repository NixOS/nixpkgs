{ stdenv, openssl, fetchFromGitHub }:
stdenv.mkDerivation {
  name = "pev-unstable-2018-07-22";
  buildInputs = [ openssl ];
  src = fetchFromGitHub {
    owner = "merces";
    repo = "pev";
    rev = "aa4ef7f"; 
    sha256 = "00a3g486343lhqcsf4vrdy5xif6v3cgcf2y8yp5b96x15c0wid36"; 
    fetchSubmodules = true;
  };

  makeFlags = [ "prefix=$(out)" ];
  installFlags = [ "prefix=$(out)" ];

  meta = with stdenv.lib; {
    description = "pev is a full-featured, open source, multiplatform command line toolkit to work with PE (Portable Executables) binaries.";
    homepage = "http://pev.sourceforge.net/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.jeschli ];
  };

}
