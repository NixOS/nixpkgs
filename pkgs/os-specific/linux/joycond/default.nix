{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, libevdev, udev, acl }:

stdenv.mkDerivation rec {
  pname = "joycond";
  version = "unstable-2021-07-30";

  src = fetchFromGitHub {
    owner = "DanielOgorchock";
    repo = "joycond";
    rev = "f9a66914622514c13997c2bf7ec20fa98e9dfc1d";
    sha256 = "sha256-quw7yBHDDZk1+6uHthsfMCej7g5uP0nIAqzvI6436B8=";
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

    substituteInPlace $out/etc/udev/rules.d/89-joycond.rules --replace \
      "/bin/setfacl"  "${acl}/bin/setfacl"
  '';

  meta = with lib; {
    homepage = "https://github.com/DanielOgorchock/joycond";
    description = "Userspace daemon to combine joy-cons from the hid-nintendo kernel driver";
    mainProgram = "joycond";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.ivar ];
    platforms = platforms.linux;
  };
}
