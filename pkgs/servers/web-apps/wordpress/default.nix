{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "wordpress";
  version = "5.4";

  src = fetchurl {
    url = "https://wordpress.org/${pname}-${version}.tar.gz";
    sha256 = "10zjgbr96ri87r5v7860vg5ndbnjfhjhily4m9nyl60f1lbjdhrr";
  };

  # exposes $WORDPRESS_CONFIG variable to configure wp-config.php path
  # upstream issue: https://core.trac.wordpress.org/ticket/41710
  patches = [ ./wordpress-wp-config.patch ];

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
