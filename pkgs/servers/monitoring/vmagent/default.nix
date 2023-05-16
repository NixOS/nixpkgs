{ lib, fetchFromGitHub, buildGoModule }:
buildGoModule rec {
  pname = "vmagent";
<<<<<<< HEAD
  version = "1.93.0";
=======
  version = "1.90.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "VictoriaMetrics";
    repo = "VictoriaMetrics";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-NkpMGsNz4knt5QY6B9sPJ3GcXEgPNyNgAsNBs9F2GOQ=";
=======
    sha256 = "sha256-XENouirZ8d92h+4KNI3K7k7e2kF3sah5DAZjlC2pVds=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  ldflags = [ "-s" "-w" "-X github.com/VictoriaMetrics/VictoriaMetrics/lib/buildinfo.Version=${version}" ];

  vendorHash = null;

  subPackages = [ "app/vmagent" ];

  meta = with lib; {
    homepage = "https://github.com/VictoriaMetrics/VictoriaMetrics/tree/master/app/vmagent";
    description = "VictoriaMetrics metrics scraper";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nullx76 ];
  };
}
