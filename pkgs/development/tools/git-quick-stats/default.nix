{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation rec {
  pname = "git-quick-stats";
  version = "2.0.15";
  src = fetchFromGitHub {
    repo = "git-quick-stats";
    owner = "arzzen";
    rev = version;
    sha256 = "1m8b0bskhpwjbs0qjp0rdzrjj613639pn92isv1cg0srj8grjcai";
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
