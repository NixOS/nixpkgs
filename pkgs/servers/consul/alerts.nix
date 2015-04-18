{ lib, goPackages, fetchFromGitHub }:

with goPackages;

buildGoPackage rec {
  name = "consul-alerts-${version}";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "AcalephStorage";
    repo = "consul-alerts";
    rev = "v${version}";
    sha256 = "02rgz68g3i408biq2aqilpqraqirzmba9mh7avdga5bljp427jgn";
  };

  goPackagePath = "github.com/AcalephStorage/consul-alerts";
  dontInstallSrc = true;
  subPackages = [ "./" ];

  meta = with lib; {
    description = "A simple daemon to send notifications based on Consul health checks";
    homepage = https://github.com/AcalephStorage/consul-alerts;
    license = licenses.gpl2;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.unix;
  };
}
