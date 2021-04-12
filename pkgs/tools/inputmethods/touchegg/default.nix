{ stdenv, lib, fetchFromGitHub, systemd, libinput, pugixml, cairo, xorg, gtk3-x11, pcre, pkg-config, cmake }:

stdenv.mkDerivation rec {
  pname = "touchegg";
  version = "2.0.8";
  src = fetchFromGitHub {
    owner = "JoseExposito";
    repo = pname;
    rev = version;
    sha256 = "1adnqlb88yljwjybz0gsb948f7svyv01k2v5x2hhwgr0k85q8ic9";
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

  nativeBuildInputs = [ pkg-config cmake ];

  meta = with lib; {
    homepage = "https://github.com/JoseExposito/touchegg";
    description = "Linux multi-touch gesture recognizer";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
