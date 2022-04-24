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

  buildInputs = [ gdk-pixbuf glib ibus libnotify librime rime-data ];
  nativeBuildInputs = [ cmake pkg-config ];

  cmakeFlags = [ "-DRIME_DATA_DIR=${rime-data}/share/rime-data" ];

  prePatch = ''
    substituteInPlace CMakeLists.txt \
       --replace 'DESTINATION "''${RIME_DATA_DIR}"' \
                 'DESTINATION "''${CMAKE_INSTALL_DATADIR}/rime-data"'
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
