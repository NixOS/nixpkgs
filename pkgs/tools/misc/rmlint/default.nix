{ stdenv, fetchFromGitHub,
  gettext, glib, json-glib, libelf, pkgconfig, scons, sphinx, utillinux }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "rmlint-${version}";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "sahib";
    repo = "rmlint";
    rev = "v${version}";
    sha256 = "1j09qk3zypw4my713q9g36kq37ggqd5v9vrs3h821p6p3qmmkdn8";
  };

  configurePhase = "scons config";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gettext glib json-glib libelf scons sphinx utillinux ];

  buildPhase = "scons";

  installPhase = "scons --prefix=$out install";

  meta = {
    description = "Extremely fast tool to remove duplicates and other lint from your filesystem";
    homepage = https://rmlint.readthedocs.org;
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = [ maintainers.koral ];
  };
}
