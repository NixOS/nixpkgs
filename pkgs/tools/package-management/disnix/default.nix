{ lib, stdenv, fetchurl, pkg-config, glib, libxml2, libxslt, getopt, gettext, dysnomia, libintl, libiconv }:

stdenv.mkDerivation rec {
  pname = "disnix";
  version = "0.10.2";

  src = fetchurl {
    url = "https://github.com/svanderburg/disnix/releases/download/${pname}-${version}/${pname}-${version}.tar.gz";
    sha256 = "0mc0wy8fca60w0d56cljq2cw1xigbp2dklb43fxa5xph94j3i49a";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ glib libxml2 libxslt getopt libintl libiconv dysnomia ];

  meta = {
    description = "A Nix-based distributed service deployment tool";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ sander tomberek ];
    platforms = lib.platforms.unix;
  };
}
