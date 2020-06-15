{ stdenv, fetchFromGitHub
, gettext, pkgconfig, scons
, glib, json-glib, libelf, sphinx, utillinux }:

with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "rmlint";
  version = "2.10.1";

  src = fetchFromGitHub {
    owner = "sahib";
    repo = "rmlint";
    rev = "v${version}";
    sha256 = "15xfkcw1bkfyf3z8kl23k3rlv702m0h7ghqxvhniynvlwbgh6j2x";
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
    homepage = "https://rmlint.readthedocs.org";
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = [ maintainers.koral ];
  };
}
