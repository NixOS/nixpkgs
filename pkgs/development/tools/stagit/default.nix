{ stdenv, libgit2, fetchgit }:

stdenv.mkDerivation rec {
  pname = "stagit";
  version = "0.9.1";

  src = fetchgit {
    url = git://git.codemadness.org/stagit;
    rev = version;
    sha256 = "0gh28spkry9wbmdj0hmvz3680fvbyzab9cifhj1p76f4fz27rnv9";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  buildInputs = [ libgit2 ];

  meta = with stdenv.lib; {
    description = "git static site generator";
    homepage = https://git.codemadness.org/stagit/;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ jb55 ];
  };
}
