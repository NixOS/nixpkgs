{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "fzy-${version}";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "jhawthorn";
    repo = "fzy";
    rev = version;
    sha256 = "1sbwy4v5kz0fcl7kzf414phxv9cppvjvfq9jqkcda4bkzqh2xgia";
  };

  makeFlags = "PREFIX=$(out)";

  meta = {
    description = "A better fuzzy finder";
    homepage = https://github.com/jhawthorn/fzy;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
  };
}
