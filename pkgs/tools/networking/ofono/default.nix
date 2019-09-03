{ stdenv
, fetchgit
, autoreconfHook
, pkgconfig
, glib
, dbus
, ell
, systemd
, bluez
, mobile-broadband-provider-info
}:

stdenv.mkDerivation rec {
  pname = "ofono";
  version = "1.30";

  outputs = [ "out" "dev" ];

  src = fetchgit {
    url = "git://git.kernel.org/pub/scm/network/ofono/ofono.git";
    rev = version;
    sha256 = "1qzysmzpgbh6zc3x9xh931wxcazka9wwx727c2k66z9gal2n6n66";
  };

  patches = [
    ./0001-Search-connectors-in-OFONO_PLUGIN_PATH.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
  ];

  buildInputs = [
    glib
    dbus
    ell
    systemd
    bluez
    mobile-broadband-provider-info
  ];

  configureFlags = [
    "--with-dbusconfdir=${placeholder "out"}/share"
    "--with-systemdunitdir=${placeholder "out"}/lib/systemd/system"
    "--enable-external-ell"
  ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Infrastructure for building mobile telephony (GSM/UMTS) applications";
    homepage = https://01.org/ofono;
    license = licenses.gpl2;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
