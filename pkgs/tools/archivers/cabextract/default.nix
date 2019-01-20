{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "cabextract-1.9";

  src = fetchurl {
    url = "https://www.cabextract.org.uk/${name}.tar.gz";
    sha256 = "1hf4zhjxfdgq9x172r5zfdnafma9q0zf7372syn8hcn7hcypkg0v";
  };

  meta = with stdenv.lib; {
    homepage = https://www.cabextract.org.uk/;
    description = "Free Software for extracting Microsoft cabinet files";
    platforms = platforms.all;
    license = licenses.gpl3;
    maintainers = with maintainers; [ pSub ];
  };
}
