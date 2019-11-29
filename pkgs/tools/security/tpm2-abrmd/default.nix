{ stdenv, fetchurl, lib
, tpm2-tss, pkgconfig, glib, which, dbus, cmocka }:

stdenv.mkDerivation rec {
  pname = "tpm2-abrmd";
  version = "2.3.0";

  src = fetchurl {
    url = "https://github.com/tpm2-software/${pname}/releases/download/${version}/${pname}-${version}.tar.gz";
    sha256 = "0l4da545174pd5z2rzbvba4a90wqlnj0lyn36gi6l7nj3yz5kjv3";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    tpm2-tss glib which dbus cmocka
  ];

  # Unit tests are currently broken as the check phase attempts to start a dbus daemon etc.
  #configureFlags = [ "--enable-unit" ];
  doCheck = false;

  meta = with lib; {
    description = "TPM2 resource manager, accessible via D-Bus";
    homepage = https://github.com/tpm2-software/tpm2-tools;
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lschuermann ];
  };
}
