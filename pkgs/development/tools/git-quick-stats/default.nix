{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation rec {
  pname = "git-quick-stats";
  version = "2.0.12";
  src = fetchFromGitHub {
    repo = "git-quick-stats";
    owner = "arzzen";
    rev = version;
    sha256 = "1diisgz8xc2ghsfdz3vh6z4vn13vvb9gf0i6qml0a46a5fqf32zb";
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
