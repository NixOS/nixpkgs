{ lib
, stdenv
, fetchFromGitHub
, cmake
, gdk-pixbuf
, glib
, ibus
, libnotify
, librime
, pkg-config
, rime-data
, symlinkJoin
, rimeDataPkgs ? [ rime-data ]
}:

stdenv.mkDerivation rec {
  pname = "ibus-rime";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "rime";
    repo = "ibus-rime";
    rev = version;
    sha256 = "0gdxg6ia0i31jn3cvh1nrsjga1j31hf8a2zfgg8rzn25chrfr319";
  };

  buildInputs = [ gdk-pixbuf glib ibus libnotify librime ];
  nativeBuildInputs = [ cmake pkg-config ];

  cmakeFlags = [ "-DRIME_DATA_DIR=${placeholder "out"}/share/rime-data" ];

  rimeDataDrv = symlinkJoin {
    name = "ibus-rime-data";
    paths = rimeDataPkgs;
  };

  postInstall = ''
    cp -r "${rimeDataDrv}/share/rime-data/." $out/share/rime-data/
  '';

  meta = with lib; {
    isIbusEngine = true;
    description = "Rime input method engine for IBus";
    homepage = "https://rime.im/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pmy ];
  };
}
