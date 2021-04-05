{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, libevdev, udev }:

stdenv.mkDerivation rec {
  pname = "joycond";
  version = "unstable-2021-03-27";

  src = fetchFromGitHub {
    owner = "DanielOgorchock";
    repo = "joycond";
    rev = "2d3f553060291f1bfee2e49fc2ca4a768b289df8";
    sha256 = "0dpmwspll9ar3pxg9rgnh224934par8h8bixdz9i2pqqbc3dqib7";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ libevdev udev ];

  # CMake has hardcoded install paths
  installPhase = ''
    mkdir -p $out/{bin,etc/{systemd/system,udev/rules.d},lib/modules-load.d}

    cp ./joycond $out/bin
    cp $src/udev/{89,72}-joycond.rules $out/etc/udev/rules.d
    cp $src/systemd/joycond.service $out/etc/systemd/system
    cp $src/systemd/joycond.conf $out/lib/modules-load.d

    substituteInPlace $out/etc/systemd/system/joycond.service --replace \
      "ExecStart=/usr/bin/joycond" "ExecStart=$out/bin/joycond"
  '';

  meta = with lib; {
    homepage = "https://github.com/DanielOgorchock/joycond";
    description = "Userspace daemon to combine joy-cons from the hid-nintendo kernel driver";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.ivar ];
    platforms = platforms.linux;
  };
}
