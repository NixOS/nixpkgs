{ stdenv, fetchFromGitHub, pkg-config, ibus, cmake, libnotify, librime, brise }:

let rime-data = "${brise}/share/rime-data";
in stdenv.mkDerivation rec {
  pname = "ibus-rime";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "rime";
    repo = "ibus-rime";
    rev = version;
    sha256 = "0zbajz7i18vrqwdyclzywvsjg6qzaih64jhi3pkxp7mbw8jc5vhy";
  };

  patches = [ ./fix-paths.patch ];

  nativeBuildInputs = [ pkg-config cmake ];

  buildInputs = [ ibus libnotify librime ];

  postPatch = ''
    # set compiled-in DATA_DIR so resources can be found
    substituteInPlace rime_config.h \
      --replace '#define IBUS_RIME_SHARED_DATA_DIR IBUS_RIME_INSTALL_PREFIX "/share/rime-data"' \
                '#define IBUS_RIME_SHARED_DATA_DIR "${rime-data}"' \
      --replace '#define IBUS_RIME_ICONS_DIR IBUS_RIME_INSTALL_PREFIX "/share/ibus-rime/icons"' \
                '#define IBUS_RIME_ICONS_DIR "${placeholder "out"}/share/ibus-rime/icons"'
  '';

  cmakeFlags = [ "-DRIME_DATA_DIR=${rime-data}" ];

  installPhase = ''
    runHook preInstall
    make --directory .. install PREFIX=$out builddir=$PWD
    runHook postInstall
  '';

  postInstall = ''
    substituteInPlace $out/share/ibus/component/rime.xml \
      --replace '/usr/lib/ibus-rime' "$out/libexec" \
      --replace '/usr/share' "$out/share"
  '';

  meta = with stdenv.lib; {
    isIbusEngine = true;
    description = "Rime Input Method Engine for Linux/IBus";
    license = licenses.gpl3;
    maintainers = with maintainers; [ mschuwalow ];
    platforms = platforms.linux;
  };
}
