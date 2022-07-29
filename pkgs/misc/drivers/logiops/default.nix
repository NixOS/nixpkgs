{ lib, stdenv, fetchFromGitHub, pkg-config, cmake, udev, libevdev, libconfig }:

stdenv.mkDerivation rec {
  pname = "logiops";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "pixlone";
    repo = "logiops";
    rev = "v${version}";
    sha256 = "sha256-1v728hbIM2ODtB+r6SYzItczRJCsbuTvhYD2OUM1+/E=";
  };

  PKG_CONFIG_SYSTEMD_SYSTEMDSYSTEMUNITDIR = "${placeholder "out"}/lib/systemd/system";

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ udev libevdev libconfig ];

  postInstall = ''
    # Remove when upstream fixes their reload mechanism (added on v0.2.3)
    sed -ie '/^ExecReload/d' $out/lib/systemd/system/logid.service
  '';

  meta = with lib; {
    description = "Unofficial userspace driver for HID++ Logitech devices";
    homepage = "https://github.com/PixlOne/logiops";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ckie ];
    platforms = with platforms; linux;
  };
}
