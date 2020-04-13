{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "dylibbundler";

  src  = fetchFromGitHub {
    owner  = "auriamg";
    repo   = "/macdylibbundler";
    rev    = "27923fbf6d1bc4d18c18e118280c4fe51fc41a80";
    sha256 = "1mpd43hvpfp7pskfrjnd6vcmfii9v3p97q0ws50krkdvshp0bv2h";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "Small command-line program that aims to make bundling .dylibs as easy as possible";
    homepage    = "https://github.com/auriamg/macdylibbundler";
    license     = licenses.mit;
    maintainers = with maintainers; [ alexfmpe ];
    platforms   = with platforms; darwin ++ linux;
  };
}
