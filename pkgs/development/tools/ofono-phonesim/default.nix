{ lib
, mkDerivation
, fetchgit
, autoreconfHook
, pkg-config
, qtbase
}:

mkDerivation {
  pname = "ofono-phonesim";
  version = "unstable-2019-11-18";

  src = fetchgit {
    url = "git://git.kernel.org/pub/scm/network/ofono/phonesim.git";
    rev = "adf231a84cd3708b825dc82c56e841dd7e3b4541";
    sha256 = "1840914sz46l8h2jwa0lymw6dvgj72wq9bhp3k4v4rk6masbf6hp";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    qtbase
  ];

  makeFlags = [
    "MOC=${qtbase.dev}/bin/moc"
    "UIC=${qtbase.dev}/bin/uic"
  ];

  meta = with lib; {
    description = "Phone Simulator for modem testing";
    homepage = "https://01.org/ofono";
    license = licenses.gpl2;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
