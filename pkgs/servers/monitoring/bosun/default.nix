{ lib, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  name = "bosun";
  rev = "0.5.0";

  src = fetchFromGitHub {
    inherit rev;
    owner = "bosun-monitor";
    repo = "bosun";
    sha256 = "1qj97wiqj6awivvac1n00k0x8wdv4ambzdj4502nmmnr5rdbqq88";
  };

  subPackages = [ "cmd/bosun" "cmd/scollector" ];
  goPackagePath = "bosun.org";

  meta = with lib; {
    description = "Time Series Alerting Framework";
    license = licenses.mit;
    homepage = https://bosun.org;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
  };
}
