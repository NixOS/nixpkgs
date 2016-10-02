{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "fzy-${version}";
  version = "0.7";

  src = fetchFromGitHub {
    owner = "jhawthorn";
    repo = "fzy";
    rev = version;
    sha256 = "11sc92j9fx23byxv5y4rq0jxp55vc9mrn5hx9lb162vdrl8a4222";
  };

  makeFlags = "PREFIX=$(out)";

  meta = {
    description = "A better fuzzy finder";
    homepage = https://github.com/jhawthorn/fzy;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
  };
}
