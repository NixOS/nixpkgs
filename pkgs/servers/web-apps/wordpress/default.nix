{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "wordpress";
  version = "5.2.2";

  src = fetchurl {
    url = "https://wordpress.org/${pname}-${version}.tar.gz";
    sha256 = "08iilbvf1gam2nmacj0a8fgldnd2gighmslf9sny8dsdlqlwjgvq";
  };

  installPhase = ''
    mkdir -p $out/share/wordpress
    cp -r . $out/share/wordpress
  '';

  meta = with stdenv.lib; {
    homepage = "https://wordpress.org";
    description = "WordPress is open source software you can use to create a beautiful website, blog, or app";
    license = [ licenses.gpl2 ];
    maintainers = [ maintainers.basvandijk ];
    platforms = platforms.all;
  };
}
