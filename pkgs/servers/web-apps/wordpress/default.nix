{ stdenv, fetchurl, nixosTests }:

stdenv.mkDerivation rec {
  pname = "wordpress";
  version = "5.4.2";

  src = fetchurl {
    url = "https://wordpress.org/${pname}-${version}.tar.gz";
    sha256 = "1pnl11yws2r2d5dfq0z85zcy5ilvm298bfs7h9z1sjakkwkh5sph";
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
