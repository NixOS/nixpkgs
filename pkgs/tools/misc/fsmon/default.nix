{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "fsmon";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "nowsecure";
    repo = "fsmon";
    rev = version;
    sha256 = "18p80nmax8lniza324kvwq06r4w2yxcq90ypk2kqym3bnv0jm938";
  };

  installPhase = ''
    make install PREFIX=$out
  '';

  meta = with stdenv.lib; {
    description = "FileSystem Monitor utility";
    homepage = "https://github.com/nowsecure/fsmon";
    license = licenses.mit;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}
