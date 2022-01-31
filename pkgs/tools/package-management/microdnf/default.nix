{ lib, stdenv, fetchFromGitHub, cmake, gettext, libdnf, pkg-config, glib, libpeas, libsmartcols, help2man }:

stdenv.mkDerivation rec {
  pname = "microdnf";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "rpm-software-management";
    repo = pname;
    rev = version;
    sha256 = "sha256-Ip1XcE8fPXhdgVaR4VPH+ElP6JbnK4JekZuWyT5ot/M=";
  };

  nativeBuildInputs = [ pkg-config cmake gettext help2man ];
  buildInputs = [ libdnf glib libpeas libsmartcols ];

  meta = with lib; {
    description = "Lightweight implementation of dnf in C";
    homepage = "https://github.com/rpm-software-management/microdnf";
    license = licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ rb2k ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
