{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "fsmon";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "nowsecure";
    repo = "fsmon";
    rev = "${version}";
    sha256 = "1b99cd5k2zh30sagp3f55jvj1r48scxibv7aqqc2sp82sci59npg";
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
