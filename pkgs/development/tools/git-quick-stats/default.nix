{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation rec {
  pname = "git-quick-stats";
  version = "2.0.16";
  src = fetchFromGitHub {
    repo = "git-quick-stats";
    owner = "arzzen";
    rev = version;
    sha256 = "03v06r6gbn8bhya1ig9wdc92hh2ip7072syxkam3sjv150ld80cn";
  };
  PREFIX = builtins.placeholder "out";
  meta = with stdenv.lib; {
    homepage = "https://github.com/arzzen/git-quick-stats";
    description = "A simple and efficient way to access various statistics in git repository";
    platforms = platforms.all;
    maintainers = [ maintainers.kmein ];
    license = licenses.mit;
  };
}
