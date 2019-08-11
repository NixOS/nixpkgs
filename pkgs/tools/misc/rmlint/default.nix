{ stdenv, fetchFromGitHub
, gettext, pkgconfig, scons
, glib, json-glib, libelf, sphinx, utillinux }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "rmlint-${version}";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "sahib";
    repo = "rmlint";
    rev = "v${version}";
    sha256 = "1gc7gbnh0qg1kl151cv1ld87vhpm1v3pnkn7prhscdcc21jrg8nz";
  };

  CFLAGS="-I${stdenv.lib.getDev utillinux}/include";

  nativeBuildInputs = [
    pkgconfig sphinx gettext scons
  ];

  buildInputs = [
    glib json-glib libelf utillinux
  ];

  prefixKey = "--prefix=";

  meta = {
    description = "Extremely fast tool to remove duplicates and other lint from your filesystem";
    homepage = https://rmlint.readthedocs.org;
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = [ maintainers.koral ];
  };
}
