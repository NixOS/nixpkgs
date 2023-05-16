{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "systemd_exporter";
  version = "0.5.0";

<<<<<<< HEAD
  vendorHash = "sha256-XkwBhj2M1poirPkWzS71NbRTshc8dTKwaHoDfFxpykU=";
=======
  vendorSha256 = "sha256-XkwBhj2M1poirPkWzS71NbRTshc8dTKwaHoDfFxpykU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "povilasv";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-q6rnD8JCtB1zTkUfZt6f2Uyo91uFi3HYI7WFlZdzpBM=";
  };

  passthru.tests = { inherit (nixosTests.prometheus-exporters) systemd; };

  meta = with lib; {
    description = "Exporter for systemd unit metrics";
    homepage = "https://github.com/povilasv/systemd_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ chkno ];
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
