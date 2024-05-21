{ lib, stdenv, fetchurl, libiconv, libshout, taglib, libxml2, pkg-config }:

stdenv.mkDerivation rec {
  pname = "ezstream";
  version = "0.6.0";

  src = fetchurl {
    url = "https://ftp.osuosl.org/pub/xiph/releases/ezstream/${pname}-${version}.tar.gz";
    sha256 = "f86eb8163b470c3acbc182b42406f08313f85187bd9017afb8b79b02f03635c9";
  };

  buildInputs = [ libiconv libshout taglib libxml2 ];
  nativeBuildInputs = [ pkg-config ];

  doCheck = true;

  meta = with lib; {
    description = "A command line source client for Icecast media streaming servers";
    longDescription = ''
      Ezstream is a command line source client for Icecast media
      streaming servers. It began as the successor of the old "shout"
      utility, and has since gained a lot of useful features.

      In its basic mode of operation, it streams media files or data
      from standard input without reencoding and thus requires only
      very little CPU resources.
    '';
    homepage = "https://icecast.org/ezstream/";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.barrucadu ];
    platforms = platforms.all;
  };
}
