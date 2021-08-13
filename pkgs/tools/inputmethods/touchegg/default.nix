{ stdenv, lib
, fetchFromGitHub
, fetchpatch
, systemd
, libinput
, pugixml
, cairo
, xorg
, gtk3-x11
, pcre
, pkg-config
, cmake
, pantheon
}:

stdenv.mkDerivation rec {
  pname = "touchegg";
  version = "2.0.11";
  src = fetchFromGitHub {
    owner = "JoseExposito";
    repo = pname;
    rev = version;
    sha256 = "1zfiqs5vqlb6drnqx9nsmhgy8qc6svzr8zyjkqvwkpbgrc6ifap9";
  };

  PKG_CONFIG_SYSTEMD_SYSTEMDSYSTEMUNITDIR = "${placeholder "out"}/lib/systemd/system";

  buildInputs = [
    systemd
    libinput
    pugixml
    cairo
    gtk3-x11
    pcre
  ] ++ (with xorg; [
    libX11
    libXtst
    libXrandr
    libXi
    libXdmcp
    libpthreadstubs
    libxcb
  ]);

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  meta = with lib; {
    homepage = "https://github.com/JoseExposito/touchegg";
    description = "Linux multi-touch gesture recognizer";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
