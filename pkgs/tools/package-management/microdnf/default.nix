{ stdenv, fetchFromGitHub, cmake, gettext, libdnf, pkg-config, glib, libpeas, libsmartcols, help2man }:

stdenv.mkDerivation rec {
  pname = "microdnf";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "rpm-software-management";
    repo = pname;
    rev = version;
    sha256 = "0a7lc3qsnblvznzsz3544l3n84184xi85zf7c3m3jhnmpmxsg39h";
  };

  nativeBuildInputs = [ pkg-config cmake gettext help2man ];
  buildInputs = [ libdnf glib libpeas libsmartcols ];

  meta = with stdenv.lib; {
    description = "Lightweight implementation of dnf in C";
    homepage = "https://github.com/rpm-software-management/microdnf";
    license = licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ rb2k ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
