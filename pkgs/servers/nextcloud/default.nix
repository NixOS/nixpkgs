{ stdenv, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  name = "nextcloud-${version}";
  version = "14.0.3";

  src = fetchurl {
    url = "https://download.nextcloud.com/server/releases/${name}.tar.bz2";
    sha256 = "1vykmvkqds1mjz9hl0xapi70s5s66xd8ysw0sczgavir7092gl6p";
  };

  patches = [ (fetchpatch {
    name = "Mailer-discover-sendmail-path-instead-of-hardcoding-.patch";
    url = https://github.com/nextcloud/server/pull/11404.patch;
    sha256 = "1h0cqnfwn735vqrm3yh9nh6a7h6srr9h29p13vywd6rqbcndqjjd";
  }) ];

  installPhase = ''
    mkdir -p $out/
    cp -R . $out/
  '';

  meta = {
    description = "Sharing solution for files, calendars, contacts and more";
    homepage = https://nextcloud.com;
    maintainers = with stdenv.lib.maintainers; [ schneefux bachp globin fpletz ];
    license = stdenv.lib.licenses.agpl3Plus;
    platforms = with stdenv.lib.platforms; unix;
  };
}
