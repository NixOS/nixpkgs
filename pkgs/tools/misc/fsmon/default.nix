{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "fsmon";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "nowsecure";
    repo = "fsmon";
    rev = version;
    sha256 = "0i7irqs4100j0g19jh64p2plbwipl6p3ld6w4sscc7n8lwkxmj03";
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
