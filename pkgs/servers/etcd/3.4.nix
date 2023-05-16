{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "etcd";
<<<<<<< HEAD
  version = "3.4.27";
=======
  version = "3.4.26";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  vendorHash = "sha256-duqOIMIXAuJjvKDM15mDdi+LZUZm0uK0MjTv2Dsl3FA=";

  doCheck = false;

  src = fetchFromGitHub {
    owner = "etcd-io";
    repo = "etcd";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-iw9rWfloK1h0M0O10AqCFKETSN6Adn71ujn4twVgsnk=";
=======
    sha256 = "sha256-EobwFYdFVCal7V1KyODuIry3ZBvRUG1/XYZkVQoibkg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildPhase = ''
    patchShebangs .
    ./build
    ./functional/build
  '';

  installPhase = ''
    install -Dm755 bin/* bin/functional/cmd/* -t $out/bin
  '';

  meta = with lib; {
    description = "Distributed reliable key-value store for the most critical data of a distributed system";
    license = licenses.asl20;
    homepage = "https://etcd.io/";
<<<<<<< HEAD
    maintainers = with maintainers; [ offline ];
=======
    maintainers = with maintainers; [ offline zowoq ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
