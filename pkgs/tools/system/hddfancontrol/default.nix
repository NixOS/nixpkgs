{ lib, python3Packages, fetchFromGitHub, hddtemp, hdparm, smartmontools }:

python3Packages.buildPythonPackage rec {
  pname = "hddfancontrol";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "desbma";
    repo = pname;
    rev = version;
    sha256 = "0b2grf98qnikayn18xll01dkm5pjpcjxdffgx1nyw9s0gqig8dg0";
  };

  propagatedBuildInputs = [
    python3Packages.python-daemon
    hddtemp
    hdparm
    smartmontools
  ];

  postInstall = ''
    mkdir -p $out/etc/systemd/system
    substitute systemd/hddfancontrol.service $out/etc/systemd/system/hddfancontrol.service \
        --replace /usr/bin/hddfancontrol $out/bin/hddfancontrol
    sed -i -e '/EnvironmentFile=.*/d' $out/etc/systemd/system/hddfancontrol.service
  '';

  meta = with lib; {
    description = "Dynamically control fan speed according to hard drive temperature on Linux";
    homepage = "https://github.com/desbma/hddfancontrol";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ benley ];
    mainProgram = "hddfancontrol";
  };
}
