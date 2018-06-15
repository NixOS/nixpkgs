{stdenv, fetchgit}:

stdenv.mkDerivation rec {
  name = "mdf2iso-${version}";
  version = "0.3.1";

  src = fetchgit {
    url    = https://anonscm.debian.org/cgit/collab-maint/mdf2iso.git;
    rev    = "5a8acaf3645bff863f9f16ea1d3632c312f01523";
    sha256 = "0f2jx8dg1sxc8y0sisqhqsqg7pj1j84fp08nahp0lfcq522pqbhl";
  };

  meta = with stdenv.lib; {
    description = "Small utility that converts MDF images to ISO format";
    homepage = src.url;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.oxij ];
  };
}
