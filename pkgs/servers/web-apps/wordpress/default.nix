{ lib, stdenv, fetchurl, nixosTests }:

stdenv.mkDerivation rec {
  pname = "wordpress";
  version = "5.6.2";

  src = fetchurl {
    url = "https://wordpress.org/${pname}-${version}.tar.gz";
    sha256 = "sha256-W9/U3i6jALXolDFraiI/a+PNPoNHim0rZHzaqSy4gkI=";
  };

  installPhase = ''
    mkdir -p $out/share/wordpress
    cp -r . $out/share/wordpress
  '';

  passthru.tests = {
    inherit (nixosTests) wordpress;
  };

  meta = with lib; {
    homepage = "https://wordpress.org";
    description = "WordPress is open source software you can use to create a beautiful website, blog, or app";
    license = [ licenses.gpl2 ];
    maintainers = [ maintainers.basvandijk ];
    platforms = platforms.all;
  };
}
