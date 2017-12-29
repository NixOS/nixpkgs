{ stdenv, libgit2, fetchgit }:

stdenv.mkDerivation rec {
  name = "stagit-${version}";
  version = "0.6";

  src = fetchgit {
    url = git://git.codemadness.org/stagit;
    rev = version;
    sha256 = "1xwjdqkf5akxa66ak7chd9gna89kgbdzjrpx4ch7f770ycp2s5sr";
  };

  makeFlags = "PREFIX=$(out)";

  buildInputs = [ libgit2 ];

  meta = with stdenv.lib; {
    description = "git static site generator";
    homepage = https://git.codemadness.org/stagit/;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ jb55 ];
  };
}
