{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "fsmon";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "nowsecure";
    repo = "fsmon";
    rev = version;
    sha256 = "1zpac37biy8jz8234q0krn7pjggz33k0grz590ravbjgfawm1ccy";
  };

  installPhase = ''
    make install PREFIX=$out
  '';

  meta = with stdenv.lib; {
    description = "FileSystem Monitor utility";
    homepage = https://github.com/nowsecure/fsmon;
    license = licenses.mit;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}
