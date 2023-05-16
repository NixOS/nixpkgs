{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "lndmon";
<<<<<<< HEAD
  version = "0.2.7";
=======
  version = "unstable-2021-03-26";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "lndmon";
<<<<<<< HEAD
    rev = "v${version}";
    hash = "sha256-j9T60J7n9sya9/nN0Y6wsPDXN2h35pXxMdadsOkAMWI=";
  };

  vendorHash = "sha256-h9+/BOy1KFiqUUV35M548fDKFC3Q5mBaANuD7t1rpp8=";

  # Irrelevant tools dependencies.
  excludedPackages = [ "./tools" ];
=======
    sha256 = "14lmmjq61p8yhc86swigs43risqi31vlmz7ri8j0n0fyp8lm2kxs";
    rev = "3aa925aa4f633a6c4d132601922e78f173ae8ac1";
  };

  vendorSha256 = "06if387b9m02ciqgcissih1x06l33djp87vgspwzz589f77vczk8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  passthru.tests = { inherit (nixosTests.prometheus-exporters) lnd; };

  meta = with lib; {
    homepage = "https://github.com/lightninglabs/lndmon";
    description = "Prometheus exporter for lnd (Lightning Network Daemon)";
    license = licenses.mit;
    maintainers = with maintainers; [ mmilata ];
  };
}
