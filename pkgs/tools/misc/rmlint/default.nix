{ stdenv, fetchFromGitHub
, gettext, pkgconfig, scons
, glib, json-glib, libelf, sphinx, utillinux }:

with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "rmlint";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "sahib";
    repo = "rmlint";
    rev = "v${version}";
    sha256 = "1b5cziam14h80xrfb285fmfrzz2rligxcpsq1xsig14xf4l2875i";
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
