{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation rec {
  pname = "git-quick-stats";
  version = "2.1.3";
  src = fetchFromGitHub {
    repo = "git-quick-stats";
    owner = "arzzen";
    rev = version;
    sha256 = "0j7yd5fcqdbsad6xzi2k0j4p06w9187hhpal1gqcrh3kj13sjyi3";
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
