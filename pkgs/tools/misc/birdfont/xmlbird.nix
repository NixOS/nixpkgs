{ stdenv, fetchurl, python3, pkgconfig, vala, glib, gobject-introspection }:

stdenv.mkDerivation rec {
  pname = "xmlbird";
  version = "1.2.10";

  src = fetchurl {
    url = "https://birdfont.org/${pname}-releases/lib${pname}-${version}.tar.xz";
    sha256 = "0qpqpqqd4wj711jzczfsr38fgcz1rzxchrqbssxnan659ycd9c78";
  };

  nativeBuildInputs = [ python3 pkgconfig vala gobject-introspection ];

  buildInputs = [ glib ];

  postPatch = "patchShebangs .";

  buildPhase = "./build.py";

  installPhase = "./install.py";
}
