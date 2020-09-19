{ stdenv, fetchurl, nixosTests }:

stdenv.mkDerivation rec {
  pname = "wordpress";
  version = "5.5.1";

  src = fetchurl {
    url = "https://wordpress.org/${pname}-${version}.tar.gz";
    sha256 = "15cjp48q23fw8ryy39mlxi4rd3rha2yqyrnk5mhx0h72ygawx8k6";
  };

  installPhase = ''
    mkdir -p $out/share/wordpress
    cp -r . $out/share/wordpress
  '';

  passthru.tests = {
    inherit (nixosTests) wordpress;
  };

  meta = with stdenv.lib; {
    homepage = "https://wordpress.org";
    description = "WordPress is open source software you can use to create a beautiful website, blog, or app";
    license = [ licenses.gpl2 ];
    maintainers = [ maintainers.basvandijk ];
    platforms = platforms.all;
  };
}
