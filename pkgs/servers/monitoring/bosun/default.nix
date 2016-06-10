{ lib, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  name = "bosun";
  rev = "0.5.0-rc4";

  src = fetchFromGitHub {
    inherit rev;
    owner = "bosun-monitor";
    repo = "bosun";
    sha256 = "0cybhy5nshg3z2h5i6r8p9d0qihcnz8s8wh5cqf17ix17k31qans";
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
