{ stdenv, fetchurl, perl, ncurses }:

stdenv.mkDerivation rec {
  version = "20190601.d1519e0";
  pname = "ipbt";

  src = fetchurl {
    url = "https://www.chiark.greenend.org.uk/~sgtatham/ipbt/ipbt-${version}.tar.gz";
    sha256 = "1aj8pajdd81vq2qw6vzfm27i0aj8vfz9m7k3sda30pnsrizm06d5";
  };

  nativeBuildInputs = [ perl ];
  buildInputs = [ ncurses ];

  meta = with stdenv.lib; {
    description = "A high-tech ttyrec player for Unix";
    homepage = "https://www.chiark.greenend.org.uk/~sgtatham/ipbt/";
    license = licenses.mit;
    maintainers = [ maintainers.tckmn ];
    platforms = platforms.unix;
  };
}
