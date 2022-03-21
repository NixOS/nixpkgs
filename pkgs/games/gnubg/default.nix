{ lib, stdenv, fetchurl, pkg-config, glib, python3, gtk2, readline }:

stdenv.mkDerivation rec {
  pname = "gnubg";
  version = "1.06.002";

  src = fetchurl {
    url = "http://gnubg.org/media/sources/gnubg-release-${version}-sources.tar.gz";
    sha256 = "11xwhcli1h12k6rnhhyq4jphzrhfik7i8ah3k32pqw803460n6yf";
  };

  nativeBuildInputs = [ pkg-config python3 glib ];
  buildInputs = [  gtk2 readline ];

  strictDeps = true;

  configureFlags = [ "--with-gtk" "--with--board3d" ];

  meta = with lib;
    { description = "World class backgammon application";
      homepage = "http://www.gnubg.org/";
      license = licenses.gpl3;
      maintainers = [ maintainers.ehmry ];
      platforms = platforms.linux;
    };
}
