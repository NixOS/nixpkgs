{ lib, stdenv, fetchurl, fetchpatch, pkg-config, glib, libxml2, libxslt, getopt, dysnomia, libintl, libiconv }:

stdenv.mkDerivation rec {
  pname = "disnix";
  version = "0.10.2";

  src = fetchurl {
    url = "https://github.com/svanderburg/disnix/releases/download/${pname}-${version}/${pname}-${version}.tar.gz";
    sha256 = "0mc0wy8fca60w0d56cljq2cw1xigbp2dklb43fxa5xph94j3i49a";
  };

  patches = [
    # https://github.com/svanderburg/disnix/pull/21
    # fix implicit function declaration
    (fetchpatch {
      name = "add-stdlib.h.patch";
      url = "https://github.com/svanderburg/disnix/commit/aa969f1d152acb35fc70c6c8db249b61f5a9eb41.patch";
      hash = "sha256-RZNVVdZ7Rx8n7qzbJOw8BHL8f07mvh8IKpfsWexuVLU=";
    })
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ glib libxml2 libxslt getopt libintl libiconv dysnomia ];

  meta = {
    description = "Nix-based distributed service deployment tool";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ sander tomberek ];
    platforms = lib.platforms.unix;
  };
}
