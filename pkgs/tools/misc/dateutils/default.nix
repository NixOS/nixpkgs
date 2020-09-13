{ stdenv, fetchurl, autoreconfHook, tzdata, fetchpatch }:

stdenv.mkDerivation rec {
  version = "0.4.7";
  pname = "dateutils";

  src = fetchurl {
    url = "https://bitbucket.org/hroptatyr/dateutils/downloads/${pname}-${version}.tar.xz";
    sha256 = "16jr9yjk8wgzfh22hr3z6mp4jm3fkacyibds4jj5xx5yymbm8wj9";
  };

  patches = [
    (fetchpatch {
      url = "https://bitbucket.org/hroptatyr/dateutils/commits/6813ed94534f2311fbe9164748919e39d60b0190/raw";
      sha256 = "1zs3iizb172ha56g03rr8kzd8zx6qypiqsc11jw758mliwxk5rgc";
    })
  ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ tzdata ]; # needed for datezone
  enableParallelBuilding = true;

  doCheck = true;

  meta = with stdenv.lib; {
    description = "A bunch of tools that revolve around fiddling with dates and times in the command line";
    homepage = "http://www.fresse.org/dateutils/";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.paperdigits ];
  };
}
