{ lib, fetchFromGitHub, goPackages }:

goPackages.buildGoPackage rec {
  name = "bosun";
  rev = "0.5.0-alpha";

  src = fetchFromGitHub {
    inherit rev;
    owner = "bosun-monitor";
    repo = "bosun";
    sha256 = "0nkphzkwx5r974skn269nnsqr4gllws5z4z6n53sslj2x9rz57ml";
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
