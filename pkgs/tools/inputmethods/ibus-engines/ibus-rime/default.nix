{ stdenv
, fetchFromGitHub
, wrapGAppsHook
, gdk-pixbuf
, pkgconfig
, cmake
, librime
, ibus
, libnotify
, brise
}:

stdenv.mkDerivation rec {
  pname = "ibus-rime";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "rime";
    repo = "ibus-rime";
    rev = version;
    sha256 = "0zbajz7i18vrqwdyclzywvsjg6qzaih64jhi3pkxp7mbw8jc5vhy";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
    wrapGAppsHook
  ];

  # FIXME: Replace brise (deprecated) with rime/plum
  buildInputs = [
    librime
    ibus
    libnotify
    brise
    gdk-pixbuf
  ];

  # cmake cannont automatically find our nonstandard brise install location
  cmakeFlags = [
    "-DRIME_DATA_DIR=${brise}/share/rime-data"
  ];

  # Fix hard-coded paths references on rime-data and icons
  preBuild = ''
    sed -i ../rime_config.h -E \
      -e "s|(IBUS_RIME_SHARED_DATA_DIR).+$|\1 \"${brise}/share/rime-data\"|" \
      -e "s|(IBUS_RIME_ICONS_DIR).+$|\1 \"$out/share/ibus-rime/icons\"|"
  '';

  # CMake script does not provide install phrase
  installPhase = ''
    install -m 755 -d $out/share/ibus/component
    install -m 644 -t $out/share/ibus/component/ ${src}/rime.xml

    install -m 755 -d $out/lib/ibus-rime
    install -m 755 -t $out/lib/ibus-rime/ ibus-engine-rime

    install -m 755 -d $out/share/ibus-rime
    install -m 755 -d $out/share/ibus-rime/icons
    install -m 644 -t $out/share/ibus-rime/icons/ ${src}/icons/*.png
  '';

  # The ibus config rime.xml hard-coded binary path for ibus-engine-rime
  postFixup = ''
    sed -i $out/share/ibus/component/rime.xml \
      -e "s|/usr/lib/ibus-rime|$out/lib/ibus-rime|" \
      -e "s|/usr/share/ibus-rime|$out/share/ibus-rime|"
  '';

  meta = with stdenv.lib; {
    isIbusEngine = true;
    homepage = https://github.com/rime/ibus-rime;
    downloadPage = https://github.com/rime/ibus-rime/releases;
    description = "【中州韻】Rime for Linux/IBus";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ holliswu ];
  };
}
