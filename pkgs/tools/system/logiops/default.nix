{ lib
, stdenv
, fetchFromGitHub
, cmake
, fetchpatch
, libconfig
, libevdev
, pkg-config
, systemd

# runtime dependency
, util-linux
}:

stdenv.mkDerivation rec {
  pname = "logiops";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "PixlOne";
    repo = pname;
    rev = "v${version}";
    sha256 = "1wgv6m1kkxl0hppy8vmcj1237mr26ckfkaqznj1n6cy82vrgdznn";
  };

  patches = [
    # Allow for systemd service to be installed at a specified path
    (fetchpatch {
      url = "https://github.com/PixlOne/logiops/pull/290/commits/926dfbbcfbfb153e87e0b93cdd90a0c33f1b9ff0.patch";
      sha256 = "sha256-F1wzK/ha3f3Ssj2HTZbH1s3uB1LeTasBt1Dghk250GY=";
    })
  ];

  cmakeFlags = [
    "-DSYSTEMD_SERVICES_INSTALL_DIR=${placeholder "out"}/share/systemd/system"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libconfig
    libevdev
    systemd # libudev
  ];

  postFixup = ''
    sed -i -e 's|/bin/kill|${util-linux}/bin/kill|g' $out/share/systemd/system/*.service
  '';

  meta = with lib; {
    description = "An unofficial userspace driver for HID++ Logitech devices";
    homepage = "https://github.com/PixlOne/logiops";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jonringer ];
  };
}
