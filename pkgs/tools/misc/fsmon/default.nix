{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "fsmon-${version}";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "nowsecure";
    repo = "fsmon";
    rev = "${version}";
    sha256 = "0sqld41jn142d4zbqmylzrnx1km7xs6r8dnmf453gyhi3yzdbr1j";
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
