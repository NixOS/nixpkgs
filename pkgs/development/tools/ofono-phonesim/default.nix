{ stdenv
, mkDerivation
, fetchFromGitHub
, autoreconfHook
, pkgconfig
, qtbase
, qtscript
}:

mkDerivation rec {
  pname = "ofono-phonesim";
  version = "unstable-2014-04-22";

  src = fetchFromGitHub {
    owner = "jpakkane";
    repo = "ofono-phonesim";
    rev = "baa41f04e6a86c5289d7185cad8a6f08a5c3ed0a";
    sha256 = "0ywalvvf3dfbn81ml21gji1n2hywh2nmakynakjzyyskcqjn2wiz";
  };

  patches = [
    ./qt5-compat.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
  ];

  buildInputs = [
    qtbase
    qtscript
  ];

  makeFlags = [
    "MOC=${qtbase.dev}/bin/moc"
    "UIC=${qtbase.dev}/bin/uic"
  ];

  meta = with stdenv.lib; {
    description = "Phone Simulator for modem testing";
    homepage = https://github.com/jpakkane/ofono-phonesim;
    license = licenses.gpl2;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
