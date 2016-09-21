{ stdenv, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  name= "nextcloud-${version}";
  version = "10.0.0";

  src = fetchurl {
    url = "https://download.nextcloud.com/server/releases/${name}.tar.bz2";
    sha256 = "07vnhw3xrady7p7y2hc3sm9bcdj21gxyx9rwgawmy28019y1gahs";
  };

  patches = [
    (fetchpatch {
      name = "env-variable.patch";
      url = "https://github.com/nextcloud/server/commit/4277051442c2b6025da936493cb674dcf754d34c.patch";
      sha256 = "1r1xcka9j9n0mkvj2nnhlwvhzicv9jjnxcszxs5g5ji88i1y0md2";
    }) # exposes $NEXTCLOUD_CONFIG_DIR for Nextcloud 10 and below
  ];

  installPhase = ''
    mkdir -p $out/
    cp -R ./* $out/
  '';

  meta = {
    description = "Sharing solution for files, calendars, contacts and more";
    homepage = https://nextcloud.com;
    maintainers = with stdenv.lib.maintainers; [ schneefux ];
    license = stdenv.lib.licenses.agpl3Plus;
    platforms = with stdenv.lib.platforms; unix;
  };
}
