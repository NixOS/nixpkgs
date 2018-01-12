{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "fzy-${version}";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "jhawthorn";
    repo = "fzy";
    rev = version;
    sha256 = "1f1sh88ivdgnqaqha5ircfd9vb0xmss976qns022n0ddb91k5ka6";
  };

  makeFlags = "PREFIX=$(out)";

  meta = {
    description = "A better fuzzy finder";
    homepage = https://github.com/jhawthorn/fzy;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
  };
}
