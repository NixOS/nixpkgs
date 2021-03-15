{ stdenv, lib, fetchFromGitHub, systemd, libinput, pugixml, cairo, xorg, gtk3-x11, pcre, pkg-config, cmake }:

stdenv.mkDerivation rec {
  pname = "touchegg";
  version = "2.0.8";
  src = fetchFromGitHub {
    owner = "JoseExposito";
    repo = pname;
    rev = "f6c64bbd6d00564a980bf4379dcc1178de294c85";
    sha256 = "1v1sskyxmvbc6j4l31zbabiklfmy2pm77bn0z0baj1dl3wy7xcj2";
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
